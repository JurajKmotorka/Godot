extends VBoxContainer

# UI References
@onready var player_health_bar = $Panel/ProgressBar
@onready var player_health_label = $Panel/ProgressBar/Label
@onready var enemy_health_bar = $Panel/ProgressBar2
@onready var enemy_health_label = $Panel/ProgressBar2/Label

@onready var player_sprite = $Panel/PlayerPanel/AnimatedSprite2D
@onready var enemy_sprite = $Panel/EnemyPanel/AnimatedSprite2D2

@onready var message_label = $Panel/Label
@onready var button_container = $Panel/ButtonContainer  # Container for dynamically created buttons

var enemy_name
signal move_selected(move_id: int)

# Initialize UI elements with stats
func setup_ui(player_data: Dictionary, enemy_data: Dictionary) -> void:
	# Set up health bars
	enemy_name = enemy_data["animal_name"]
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
	display_message("A wild %s appears! Prepare for battle!" % enemy_name)

	# Set up move buttons based on the provided move list
	setup_move_buttons(player_data["moves"])

# Set up move buttons dynamically based on the available moves
func setup_move_buttons(move_list: Array) -> void:
	# Remove all existing children from the ButtonContainer
	for child in button_container.get_children():
		button_container.remove_child(child)

	# Loop through each move and create a button for it
	for move in move_list:
		var button = Button.new()
		button.text = move
		
		# Connect the "pressed" signal to a function that informs the BattleManager
		button.pressed.connect(self._on_move_button_pressed.bind(move))
		button_container.add_child(button)

# Handle button press to notify the BattleManager
func _on_move_button_pressed(move: String) -> void:
	# Disable move buttons during action
	disable_buttons(true)
	# Notify the BattleManager to handle the move
	emit_signal("move_selected", move)
	# Play the player's animation, then stop it after a delay
	if player_sprite.sprite_frames.has_animation("walk"):
		player_sprite.play("walk")
		await get_tree().create_timer(2).timeout  # Adjust the delay to match the animation duration
		player_sprite.stop()

	

	# Simulate enemy response after a short delay
	await get_tree().create_timer(0.5).timeout
	await enemy_turn()

# Handle the enemy's turn
func enemy_turn() -> void:
	# Play the enemy's animation, then stop it after a delay
	if enemy_sprite.sprite_frames.has_animation("walk"):
		enemy_sprite.play("walk")
		await get_tree().create_timer(2).timeout  # Adjust the delay to match the animation duration
		enemy_sprite.stop()

	# Continue to the next turn
	display_message("Your turn!")
	disable_buttons(false)

# Update the health bars and labels for both the player and enemy
func update_health(player_health: int, player_max_health: int, enemy_health: int, enemy_max_health: int) -> void:
	# Update player health bar and label
	player_health_bar.value = player_health
	player_health_label.text = "%d/%d" % [player_health, player_max_health]

	# Update enemy health bar and label
	enemy_health_bar.value = enemy_health
	enemy_health_label.text = "%d/%d" % [enemy_health, enemy_max_health]

	# Check for victory or defeat
	if player_health <= 0:
		display_message("You have been defeated!")
		disable_buttons(true)
	elif enemy_health <= 0:
		display_message("You defeated %s!" % enemy_name)
		disable_buttons(true)

# Display battle messages
func display_message(message: String) -> void:
	message_label.text = message

# Enable or disable move buttons
func disable_buttons(disable: bool) -> void:
	for button in button_container.get_children():
		button.disabled = disable
