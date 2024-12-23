extends Node

var effect_manager = preload("res://effect_manager.gd").new()
var move_data = {}

# Applies the move and calculates damage based on stats
func apply_move(attacker: Dictionary, defender: Dictionary, move: String) -> String:
	if not move:
		print("No move provided!")
		return "No move was selected."
	
	move_data = MoveDatabase.get_move(move)

	var messages = []  # Collect messages to return
	print("Applying move: %s" % move)

	# Precision Check: Determine if the move hits
	if not _does_move_hit(attacker, move):
		messages.append("%s used %s, but it missed!" % [attacker["animal_name"], move])
		return "\n".join(messages)  # Return immediately if missed

	# Calculate damage
	var damage = calculate_damage(attacker, defender, move)
	if damage > 0:
		# Update defender's health
		defender["current_health"] -= damage
		defender["current_health"] = max(defender["current_health"], 0)
		messages.append("%s used %s and dealt %d damage!" % [attacker["animal_name"], move, damage])
	else:
		messages.append("%s used %s!" % [attacker["animal_name"], move])

	# Apply effects (if any)
	if move_data["effect"] != null:
		effect_manager.apply_effect(move_data["effect"], attacker)
		messages.append(_get_effect_message(move_data["effect"], attacker, defender))

	# Resolve effects (e.g., DoTs or buffs applied at the turn end)
	effect_manager.resolve_effects(attacker, defender)

	return "\n".join(messages)

# Precision check: Determines if a move hits based on the attacker's precision
func _does_move_hit(attacker: Dictionary, move: String) -> bool:
	var precision = move_data["precision"] # Default precision to 100 if not set
	precision = min(max(precision, 1), 100)  # Clamp precision between 1 and 100
	var roll = randi() % 100 + 1  # Random roll between 1 and 100
	print("Move Precision: %d, Roll: %d" % [precision, roll])
	return roll <= precision

# Generate effect messages
func _get_effect_message(effect: Dictionary, attacker: Dictionary, defender: Dictionary) -> String:
	match effect["type"]:
		"damage_over_time":
			return "%s has been poisoned!" % [defender["animal_name"]]
		"stat_buff":
			return "%s's %s has been increased!" % [attacker["animal_name"], effect["stat"]]
		"stat_debuff":
			return "%s's %s has been reduced!" % [defender["animal_name"], effect["stat"]]
		"heals":
			return "%s is healed for %d HP!" % [attacker["animal_name"], effect["value"]]
	return "%s has been affected by %s!" % [attacker["animal_name"], effect["status"]]

# Calculate damage
func calculate_damage(attacker: Dictionary, defender: Dictionary, move: String) -> int:
	if move_data["damage"] <= 0:
		return 0

	var final_damage = move_data["damage"] * attacker["attack_power"] / defender["defense"]
	return max(final_damage, 1)
