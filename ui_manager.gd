extends VBoxContainer

# UI References
@onready var player_health_bar = $Panel/ProgressBar
@onready var player_health_label = $Panel/ProgressBar/Label
@onready var enemy_health_bar = $Panel/ProgressBar2
@onready var enemy_health_label = $Panel/ProgressBar2/Label

@onready var player_sprite = $AnimatedSprite2D
@onready var enemy_sprite = $AnimatedSprite2D2

@onready var message_label = $Panel/Label
@onready var button_container = $Panel/ButtonContainer  # Container for dynamically created button

signal move_selected(move_id: int)


# Initialize UI elements with stats
func setup_ui(player_data: Dictionary, enemy_data: Dictionary) -> void:
	# Set up health bars
	player_health_bar.max_value = player_data["max_health"]
	player_health_bar.value = player_data["current_health"]
	player_health_label.text = "%d/%d" % [player_data["current_health"], player_data["max_health"]]
	
	enemy_health_bar.max_value = enemy_data["max_health"]
	enemy_health_bar.value = enemy_data["current_health"]
	enemy_health_label.text = "%d/%d" % [enemy_data["current_health"], enemy_data["max_health"]]

	# Load sprites
	player_sprite.sprite_frames = load(player_data["sprite_frames"])
	enemy_sprite.sprite_frames = load(enemy_data["sprite_frames"])

	# Display initial message
	display_message("A wild %s appears! Prepare for battle!")

	# Set up move buttons based on the provided move list
	setup_move_buttons(player_data["moves"])

# Set up move buttons dynamically based on the available moves
func setup_move_buttons(move_list: Array) -> void:
	# Remove all existing children from the GridContainer
	for child in button_container.get_children():
		button_container.remove_child(child)

	# Loop through each move and create a button for it
	for move in move_list:
		# Create a new button
		var button = Button.new()
		button.text = MoveDatabase.get_move(move)["move"]
		
		# Connect the "pressed" signal to a function that informs the BattleManager
		button.pressed.connect(self._on_move_button_pressed.bind(move))
		
		# Add the button to the container
		button_container.add_child(button)

# Handle button press to notify the BattleManager
func _on_move_button_pressed(move: int) -> void:
	# Display the message for the selected move
	display_message("You used %s!" % MoveDatabase.get_move(move)["move"])

	# Notify the BattleManager to handle the move
	emit_signal("move_selected", move)

# Update the health bars and labels for both the player and enemy
func update_health(player_health: int, player_max_health: int, enemy_health: int, enemy_max_health: int) -> void:
	# Update player health bar and label
	player_health_bar.value = player_health
	player_health_label.text = "%d/%d" % [player_health, player_max_health]

	# Update enemy health bar and label
	enemy_health_bar.value = enemy_health
	enemy_health_label.text = "%d/%d" % [enemy_health, enemy_max_health]

	# Optional: If health reaches zero, display a "Game Over" message or other feedback
	if player_health <= 0:
		display_message("You have been defeated!")
	elif enemy_health <= 0:
		display_message("You defeated %s!" % [enemy_health_label.text])

# Display battle messages
func display_message(message: String) -> void:
	message_label.text = message
