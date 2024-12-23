extends Node

@onready var move_manager = $MoveManager
@onready var ui_manager = $UIManager
@onready var stats_manager = $StatsManager

var player_deck = []
var enemy_deck = []
var enemy_id: int
var player_active_index = 0
var enemy_active_index = 0
var is_battle_over = false
var is_player_turn = true

signal battle_result(won: bool)
signal enemy_data_ready


func set_enemy_data(animal_id: int):
	enemy_deck = [stats_manager.initialize_stats(AnimalDatabase.get_animal(animal_id), 20)]
	enemy_id = animal_id
	emit_signal("enemy_data_ready")

func _ready():
	# Initialize player's deck
	player_deck = []
	for animal_id in AnimalDeck.get_selected_animals():
		player_deck.append(stats_manager.initialize_stats(AnimalDatabase.get_animal(animal_id), 20))

	# Check if enemy data is ready
	if enemy_deck.is_empty():
		await self.enemy_data_ready  # Wait for the 'enemy_data_ready' signal emitted by this script

	_update_active_animals()
	_display_message("A wild %s appears!" % enemy_deck[enemy_active_index]["animal_name"])

	is_player_turn = player_deck[player_active_index]["speed"] >= enemy_deck[enemy_active_index]["speed"]
	if not is_player_turn:
		enemy_turn()

	ui_manager.move_selected.connect(_on_move_selected)


# Update active animals when an animal is defeated
func _update_active_animals():
	player_active_index = get_next_active_index(player_deck, player_active_index)
	enemy_active_index = get_next_active_index(enemy_deck, enemy_active_index)
	ui_manager.setup_ui(player_deck[player_active_index], enemy_deck[enemy_active_index])

func get_next_active_index(deck: Array, current_index: int) -> int:
	for i in range(current_index, len(deck)):
		if deck[i]["current_health"] > 0:
			return i
	return -1  # No active animal left

# Player selects a move
func _on_move_selected(move_id: String) -> void:
	if is_battle_over or not is_player_turn:
		return

	_display_message("You used %s!" % move_id)

	var move_message = move_manager.apply_move(player_deck[player_active_index], enemy_deck[enemy_active_index], move_id)
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
	var move_id = enemy_deck[enemy_active_index]["moves"].pick_random()

	_display_message("Enemy used %s!" % move_id)
	var move_message = move_manager.apply_move(enemy_deck[enemy_active_index], player_deck[player_active_index], move_id)
	_display_message(move_message)

	_check_battle_over()
	if not is_battle_over:
		is_player_turn = true

# Check if battle is over
func _check_battle_over() -> void:
	if enemy_deck[enemy_active_index]["current_health"] <= 0:
		if get_next_active_index(enemy_deck, enemy_active_index + 1) == -1:
			_display_message("You defeated all enemies!")
			emit_signal("battle_result", true)
			for animal in enemy_deck:
				AnimalDeck.add_to_deck(enemy_id)
			is_battle_over = true
		else:
			_display_message("Enemy replaced their animal!")
			_update_active_animals()

	elif player_deck[player_active_index]["current_health"] <= 0:
		if get_next_active_index(player_deck, player_active_index + 1) == -1:
			_display_message("You were defeated...")
			emit_signal("battle_result", false)
			is_battle_over = true
		else:
			_display_message("You replaced your animal!")
			_update_active_animals()

	_update_ui()
	if is_battle_over:
		await get_tree().create_timer(2.0).timeout
		_return_to_main_scene()

func _return_to_main_scene() -> void:
	var main_scene = load("res://map.tscn").instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(main_scene)
	get_tree().current_scene = main_scene

func _update_ui():
	ui_manager.update_health(
		player_deck[player_active_index]["current_health"], player_deck[player_active_index]["max_health"], 
		enemy_deck[enemy_active_index]["current_health"], enemy_deck[enemy_active_index]["max_health"]
	)

func _display_message(msg: String):
	ui_manager.display_message(msg)
