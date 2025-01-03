extends Control

# Called when the node enters the scene tree
func _ready() -> void:
	# Connect button signals using the new syntax
	$"MarginContainer/VBoxContainer/Button".pressed.connect(_on_start_game_pressed)
	$"MarginContainer/VBoxContainer/Button2".pressed.connect(_on_load_game_pressed)
	$"MarginContainer/VBoxContainer/Button3".pressed.connect(_on_settings_pressed)
	$"MarginContainer/VBoxContainer/Button4".pressed.connect(_on_exit_pressed)


# Start Game button pressed
func _on_start_game_pressed() -> void:
	print("Start Game pressed")
	var game_scene = load("res://main.tscn")
	get_tree().change_scene_to_packed(game_scene)

# Load Game button pressed
func _on_load_game_pressed() -> void:
	print("Load Game pressed")
	# Load the saved game and switch to the game scene
	# (This assumes your save system is implemented)
	var game_scene = load("res://main.tscn")
	AnimalDeck.load_game()
	get_tree().change_scene_to_packed(game_scene)

# Settings button pressed
func _on_settings_pressed() -> void:
	print("Settings pressed")
	# Load settings menu or show a popup

# Exit button pressed
func _on_exit_pressed() -> void:
	print("Exit pressed")
	get_tree().quit()
