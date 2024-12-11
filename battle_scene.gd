extends Node

var player_stats = {}
var enemy_stats = {}
var battle_over = false
signal battle_won(enemy_name: String)

func _ready() -> void:
	player_stats = AnimalDatabase.get_animal(1)
	enemy_stats = AnimalDatabase.get_animal(4)

	# Initialize effects for both combatants
	
	player_stats["effects"] = {}
	enemy_stats["effects"] = {}

	$VBoxContainer/Panel/ProgressBar.max_value = player_stats["max_health"]
	$VBoxContainer/Panel/ProgressBar2.max_value = enemy_stats["max_health"]
	_update_health_bars()	

	$VBoxContainer/AnimatedSprite2D.sprite_frames = load(player_stats["sprite_frames"])
	$VBoxContainer/AnimatedSprite2D2.sprite_frames = load(enemy_stats["sprite_frames"])

	_display_message("A wild %s appears! Prepare for battle!" % enemy_stats["name"])
	_setup_move_buttons()

# Dynamically create move buttons for the player
func _setup_move_buttons() -> void:
	var button_container = $VBoxContainer/Panel/ButtonContainer
	
	# Clear existing buttons
	for child in button_container.get_children():
		child.queue_free()
	
	# Add new buttons for each move
	for move in player_stats["moves"]:
		var button = Button.new()
		button.text = move["name"]
		button_container.add_child(button)
		button.pressed.connect(func():
			_on_move_button_pressed(move))

# Handle move button press
func _on_move_button_pressed(move: Dictionary) -> void:
	if battle_over:
		return

	apply_move(player_stats, enemy_stats, move)

	if enemy_stats["current_health"] <= 0:
		_battle_won()
	else:
		animal_turn()

# Enemy turn
func animal_turn():
	if battle_over:
		return

	await get_tree().create_timer(1.0).timeout
	var random_index = randi() % enemy_stats["moves"].size()
	var move = enemy_stats["moves"][random_index]
	apply_move(enemy_stats, player_stats, move)

	if player_stats["current_health"] <= 0:
		_battle_lost()

# Apply move logic
func move_hits(precision: int) -> bool:
	var roll = randi() % 100
	return roll < precision

func apply_move(attacker: Dictionary, target: Dictionary, move: Dictionary) -> void:
	if move_hits(move["precision"]):
		var base_damage = move["damage"]
		var adjusted_damage = calculate_damage(attacker, target, base_damage)
		target["current_health"] -= adjusted_damage
		target["current_health"] = clamp(target["current_health"], 0, target["max_health"])
		_display_message("%s used %s! It dealt %d damage!" % [attacker["name"], move["name"], adjusted_damage])
	else:
		_display_message("%s used %s, but it missed!" % [attacker["name"], move["name"]])

	if move.has("effect") and move["effect"] != null:
		apply_effect(target, move["effect"])

	_update_health_bars()

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

func apply_effect(target: Dictionary, effect: String) -> void:
	if not target["effects"].has(effect):
		target["effects"][effect] = 0
	target["effects"][effect] += 1

	if effect == "lowers_attack":
		apply_attack_debuff(target)
		_display_message("%s's attack is lowered!" % target["name"])

func apply_attack_debuff(target: Dictionary) -> void:
	if not target.has("base_attack_power"):
		target["base_attack_power"] = target["attack_power"]

	var debuff_stack = target["effects"].get("lowers_attack", 0)
	var debuff_multiplier = 1.0 - (min(3, debuff_stack) * 0.2)
	target["attack_power"] = target["base_attack_power"] * debuff_multiplier

# Battle won
func _battle_won():
	battle_over = true
	_display_message("You defeated the %s!" % enemy_stats["name"])
	emit_signal("battle_won", enemy_stats["name"])

	await get_tree().create_timer(2.0).timeout
	get_tree().current_scene.visible = true
	queue_free()

# Battle lost
func _battle_lost():
	battle_over = true
	_display_message("You were defeated...")
	await get_tree().create_timer(2.0).timeout
	get_tree().current_scene.visible = true
	queue_free()

func _update_health_bars():
	$VBoxContainer/Panel/ProgressBar.set_value(player_stats["current_health"])
	$VBoxContainer/Panel/ProgressBar2.set_value(enemy_stats["current_health"])
	$VBoxContainer/Panel/ProgressBar/Label.text = "%d/%d" % [player_stats["current_health"], player_stats["max_health"]]
	$VBoxContainer/Panel/ProgressBar2/Label.text = "%d/%d" % [enemy_stats["current_health"], enemy_stats["max_health"]]

func _display_message(msg: String):
	$VBoxContainer/Panel/Label.text = msg
