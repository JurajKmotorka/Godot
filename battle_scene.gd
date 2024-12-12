extends Node

var player_data = {}
var enemy_data = {}
var animal_id = 0
var is_battle_over = false
signal battle_result(won: bool, animal_id: int)
signal enemy_ready

# Set enemy data and signal readiness
func set_enemy_data(id: int):
	enemy_data = AnimalDatabase.get_animal(id)
	animal_id = id
	print(enemy_data)
	emit_signal("enemy_ready")

func _ready() -> void:
	# Wait for enemy data to load
	if enemy_data.size() == 0:
		await self.enemy_ready

	player_data = AnimalDatabase.get_animal(1)

	# Initialize combat stats
	player_data["effects"] = {}
	enemy_data["effects"] = {}

	$VBoxContainer/Panel/ProgressBar.max_value = player_data["max_health"]
	$VBoxContainer/Panel/ProgressBar2.max_value = enemy_data["max_health"]
	_update_health_bars()

	$VBoxContainer/AnimatedSprite2D.sprite_frames = load(player_data["sprite_frames"])
	$VBoxContainer/AnimatedSprite2D2.sprite_frames = load(enemy_data["sprite_frames"])

	_display_message("A wild %s appears! Prepare for battle!" % enemy_data["animal_name"])
	_create_move_buttons()

# Create move buttons dynamically
func _create_move_buttons() -> void:
	var button_container = $VBoxContainer/Panel/ButtonContainer
	
	# Clear any existing buttons
	for button in button_container.get_children():
		button.queue_free()
	
	# Add buttons for each move
	for move in player_data["moves"]:
		var button = Button.new()
		button.text = move["move"]
		button_container.add_child(button)
		button.pressed.connect(func():
			_on_move_selected(move))

# Handle player's move selection
func _on_move_selected(move: Dictionary) -> void:
	if is_battle_over:
		return

	apply_move(player_data, enemy_data, move)

	if enemy_data["current_health"] <= 0:
		end_battle(true)
	else:
		enemy_turn()

# Enemy's turn logic
func enemy_turn():
	if is_battle_over:
		return

	await get_tree().create_timer(1.0).timeout
	var random_move = enemy_data["moves"][randi() % enemy_data["moves"].size()]
	apply_move(enemy_data, player_data, random_move)

	if player_data["current_health"] <= 0:
		end_battle(false)

# Check if a move hits based on precision
func move_hits(precision: int) -> bool:
	return randi() % 100 < precision

# Apply the selected move
func apply_move(attacker: Dictionary, target: Dictionary, move: Dictionary) -> void:
	if move_hits(move["precision"]):
		var base_damage = move["damage"]
		var actual_damage = calculate_damage(attacker, target, base_damage)
		target["current_health"] -= actual_damage
		target["current_health"] = clamp(target["current_health"], 0, target["max_health"])
		_display_message("%s used %s! It dealt %d damage!" % [attacker["animal_name"], move["move"], actual_damage])
	else:
		_display_message("%s used %s, but it missed!" % [attacker["animal_name"], move["move"]])

	if move.has("effect") and move["effect"]:
		apply_effect(target, move["effect"])

	_update_health_bars()

# Calculate damage with multipliers
func calculate_damage(attacker: Dictionary, target: Dictionary, base_damage: int) -> int:
	var multiplier = 1.0
	if attacker["class"] == "Beast" and target["class"] == "Bird":
		multiplier *= 2.0
	elif attacker["class"] == "Bird" and target["class"] == "Serpent":
		multiplier *= 2.0
	elif attacker["class"] == "Serpent" and target["class"] == "Beast":
		multiplier *= 2.0
	elif attacker["class"] == "Fish" and target["class"] != "Worm":
		multiplier *= 0.75
	elif target["class"] == "Fish" and attacker["class"] != "Worm":
		multiplier *= 0.5
	return int((attacker["attack_power"] * base_damage / 10) * multiplier)

# Apply move effects
func apply_effect(target: Dictionary, effect: String) -> void:
	if not target["effects"].has(effect):
		target["effects"][effect] = 0
	target["effects"][effect] += 1

	if effect == "lowers_attack":
		apply_attack_debuff(target)
		_display_message("%s's attack is lowered!" % target["animal_name"])

# Apply attack debuff logic
func apply_attack_debuff(target: Dictionary) -> void:
	if not target.has("base_attack_power"):
		target["base_attack_power"] = target["attack_power"]

	var debuff_count = target["effects"].get("lowers_attack", 0)
	var debuff_multiplier = 1.0 - (min(3, debuff_count) * 0.2)
	target["attack_power"] = target["base_attack_power"] * debuff_multiplier

# End the battle and emit the result
func end_battle(won: bool):
	is_battle_over = true
	emit_signal("battle_result", true, animal_id)

	if won:
		_display_message("You defeated %s!" % enemy_data["animal_name"])
	else:
		_display_message("You were defeated...")

	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://map.tscn")

# Update the health bars
func _update_health_bars():
	$VBoxContainer/Panel/ProgressBar.value = player_data["current_health"]
	$VBoxContainer/Panel/ProgressBar2.value = enemy_data["current_health"]
	$VBoxContainer/Panel/ProgressBar/Label.text = "%d/%d" % [player_data["current_health"], player_data["max_health"]]
	$VBoxContainer/Panel/ProgressBar2/Label.text = "%d/%d" % [enemy_data["current_health"], enemy_data["max_health"]]

# Display messages during battle
func _display_message(msg: String):
	$VBoxContainer/Panel/Label.text = msg
