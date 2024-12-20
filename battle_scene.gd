extends Node

@onready var move_manager = $MoveManager
@onready var ui_manager = $UIManager
@onready var stats_manager = $StatsManager

var player_data = {}
var enemy_data = {}
var is_battle_over = false
var is_player_turn = true

signal enemy_data_ready
signal battle_result(won: bool)

func set_enemy_data(animal_id: int):
	enemy_data = stats_manager.initialize_stats(AnimalDatabase.get_animal(animal_id), 1, player_data["class"])
	emit_signal("enemy_data_ready")

func _ready():
	player_data = stats_manager.initialize_stats(AnimalDatabase.get_animal(AnimalDeck.get_selected_animals()[0]), 1)
	if enemy_data.is_empty():
		await self.enemy_data_ready

	ui_manager.setup_ui(player_data, enemy_data)
	_update_ui()
	_display_message("A wild %s appears!" % enemy_data["animal_name"])

	is_player_turn = player_data["speed"] >= enemy_data["speed"]
	if not is_player_turn:
		enemy_turn()
	ui_manager.move_selected.connect(_on_move_selected)

# Player selects a move
func _on_move_selected(move_id: int) -> void:
	if is_battle_over or not is_player_turn:
		return

	var move = MoveDatabase.get_move(move_id)
	_display_message("You used %s!" % move["move"])

	# Get the messages (damage and effects) from the move
	var move_message = move_manager.apply_move(player_data, enemy_data, move)
	_display_message(move_message)

	_check_battle_over()
	if not is_battle_over:
		is_player_turn = false
		enemy_turn()

# Enemy turn logic
func enemy_turn() -> void:
	if is_battle_over:
		return

	await get_tree().create_timer(1.0).timeout
	var move_id = enemy_data["moves"].pick_random()
	var move = MoveDatabase.get_move(move_id)

	_display_message("Enemy used %s!" % move["move"])
	var move_message = move_manager.apply_move(enemy_data, player_data, move)
	_display_message(move_message)

	_check_battle_over()
	if not is_battle_over:
		is_player_turn = true

# Check if battle is over
func _check_battle_over() -> void:
	if enemy_data["current_health"] <= 0:
		_display_message("You defeated %s!" % enemy_data["animal_name"])
		emit_signal("battle_result", true)
		is_battle_over = true
	elif player_data["current_health"] <= 0:
		_display_message("You were defeated...")
		emit_signal("battle_result", false)
		is_battle_over = true

	_update_ui()
	if is_battle_over:
		await get_tree().create_timer(5.0).timeout
		_return_to_main_scene()

func _return_to_main_scene() -> void:
	var main_scene = load("res://map.tscn").instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(main_scene)
	get_tree().current_scene = main_scene
	get_tree().call_deferred("_set_player_position")

func _set_player_position() -> void:
	var player = get_tree().current_scene.get_node("Player")
	if player:
		player.position = GlobalData.player_position

func _update_ui():
	ui_manager.update_health(player_data["current_health"], player_data["max_health"], 
		enemy_data["current_health"], enemy_data["max_health"])

func _display_message(msg: String):
	ui_manager.display_message(msg)
