extends Node

var effect_manager = preload("res://effect_manager.gd").new()

# Applies the move and calculates damage based on stats
func apply_move(attacker: Dictionary, defender: Dictionary, move: Dictionary) -> String:
	if not move:
		print("No move provided!")
		return "No move was selected."

	print("Attacker move data: ", move)  # Log the move data to check if it's correct
	var damage = calculate_damage(attacker, defender, move)
	
	# Log move and health changes for debugging
	print("Applying move: %s, Damage: %d" % [move["move"], damage])
	print("Defender health before: %d" % defender["current_health"])

	# Update the defender's health after applying the damage
	defender["current_health"] -= damage
	defender["current_health"] = max(defender["current_health"], 0)  # Prevent negative health
	
	# Log health after applying the move
	print("Defender health after: %d" % defender["current_health"])

	# Apply any effects if the move has an effect
	if move["effect"] != null:
		print("Applying effect: ", move["effect"])  # Debugging
		effect_manager.apply_effect(move["effect"], defender)
	else:
		print("No effect to apply for this move.")

	return "%s uses %s! It deals %d damage!" % [attacker["animal_name"], move["move"], damage]

# Calculate the damage based on stats and move
func calculate_damage(attacker: Dictionary, defender: Dictionary, move: Dictionary) -> int:
	var base_damage = move["damage"]
	var final_damage = (attacker["attack_power"] * base_damage) / (defender["defense"] + 1)

	# Debugging: Check the damage calculation values
	print("Attacker attack power: ", attacker["attack_power"])
	print("Base damage: ", base_damage)
	print("Defender defense: ", defender["defense"])
	print("Final damage: ", final_damage)

	# Apply additional effects (e.g., status effects)
	if move["effect"] != null:
		print("Applying effect (additional): ", move["effect"])  # Debugging
		effect_manager.apply_effect(move["effect"], defender)

	return max(final_damage, 1)

# Get available moves for an animal based on its level
func get_available_moves(animal: Dictionary) -> Array:
	return animal["available_moves"].filter(func(move): return move["required_level"] <= animal["level"])
