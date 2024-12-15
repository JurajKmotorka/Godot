extends Node

@onready var move_manager = $MoveManager
@onready var ui_manager = $UIManager
@onready var stats_manager = $StatsManager

var player_data = {}
var enemy_data = {}
var is_battle_over = false
var is_player_turn = true

signal enemy_data_ready  # Signal emitted when enemy_data is set
signal battle_result(won: bool)

func set_enemy_data(animal_id: int):
	enemy_data = stats_manager.initialize_stats(AnimalDatabase.get_animal(animal_id), 1, player_data["class"])
	print("Enemy data initialized: ", enemy_data)
	emit_signal("enemy_data_ready")  # Notify that enemy data is ready

func _ready():
	# Initialize player stats
	player_data = stats_manager.initialize_stats(AnimalDatabase.get_animal(1), 1)
	print("Player data initialized: ", player_data)

	# Wait for enemy_data to be set
	if enemy_data.is_empty():
		print("Waiting for enemy data...")
		await self.enemy_data_ready  # Wait for the signal
	print("Enemy data ready. Proceeding with UI setup...")

	# Set up the UI
	ui_manager.setup_ui(player_data, enemy_data)
	_update_ui()
	_display_message("A wild %s appears!" % enemy_data["animal_name"])

	# Determine turn order
	is_player_turn = player_data["speed"] >= enemy_data["speed"]
	if not is_player_turn:
		enemy_turn()
# Connect the "move_selected" signal to the method in BattleManager
	ui_manager.move_selected.connect(_on_move_selected)

# Handle when a move is selected (this method is now connected to the UIManager's signal)
func _on_move_selected(move_id: int) -> void:
	if is_battle_over or not is_player_turn:
		return

	var move = MoveDatabase.get_move(move_id)
	_display_message("You used %s!" % move["move"])

	# Apply the move's effect (handled by the move manager or other battle systems)
	move_manager.apply_move(player_data, enemy_data, move)

	_check_battle_over()

	is_player_turn = false
	enemy_turn()

func enemy_turn() -> void:
	if is_battle_over:
		return

	await get_tree().create_timer(1.0).timeout
	var move_id = enemy_data["moves"].pick_random()
	var move = MoveDatabase.get_move(move_id)

	_display_message(move_manager.apply_move(enemy_data, player_data, move))
	_check_battle_over()
	is_player_turn = true

func _check_battle_over() -> void:
	if enemy_data["current_health"] <= 0:
		emit_signal("battle_result", true)
		_display_message("You defeated %s!" % enemy_data["animal_name"])
		is_battle_over = true
	elif player_data["current_health"] <= 0:
		emit_signal("battle_result", false)
		_display_message("You were defeated...")
		is_battle_over = true

	_update_ui()

func _update_ui():
	ui_manager.update_health(player_data["current_health"], player_data["max_health"], enemy_data["current_health"], enemy_data["max_health"])

func _display_message(msg: String):
	ui_manager.display_message(msg)
