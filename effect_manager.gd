extends Node

# Tracks active effects per animal
var active_effects: Dictionary = {}

# Apply an effect to a target animal
func apply_effect(effect: Dictionary, target: Dictionary) -> void:
	if effect.size() == 0 or not effect.has("type"):
		print("No valid effect to apply.")
		return

	# Ensure the target has a list for active effects
	var target_effects = active_effects.get(target["animal_name"], [])
	
	# Clone and set effect duration
	var applied_effect = effect.duplicate(true)
	applied_effect["remaining_duration"] = effect.get("duration", -1)  # Default to unlimited duration
	
	# Append the effect and update the dictionary
	target_effects.append(applied_effect)
	active_effects[target["animal_name"]] = target_effects
	print("Effect applied to %s: %s" % [target["animal_name"], applied_effect])

# Resolve and apply ongoing effects
func resolve_effects(attacker: Dictionary, defender: Dictionary) -> void:
	print("Resolving effects for: %s" % attacker["animal_name"])
	if not active_effects.has(attacker["animal_name"]):
		print("No active effects for %s." % attacker["animal_name"])
		return

	var effects_to_remove = []

	# Process each active effect
	for effect in active_effects[attacker["animal_name"]]:
		print("Processing effect: %s" % effect)

		# Apply the effect based on its type
		match effect["type"]:
			"damage_over_time":
				defender["current_health"] -= effect["value"]
				display_message("%s is affected by %s and takes %d damage!" % [
					defender["animal_name"], effect.get("name", "an effect"), effect["value"]])
			"stat_buff":
				var stat = effect["stat"]
				attacker[stat] *= 1.2
				display_message("%s's %s was increased!" % [attacker["animal_name"], stat])
			"stat_debuff":
				if effect.has("stats"):  # Handle multiple stats
					for stat in effect["stats"]:
						if stat in defender:
							defender[stat] *= 0.8
							display_message("%s's %s was reduced!" % [defender["animal_name"], stat])
				elif effect.has("stat"):  # Handle single stat (fallback for legacy)
					var stat = effect["stat"]
					if stat in defender:
						defender[stat] *= 0.8
						display_message("%s's %s was reduced!" % [defender["animal_name"], stat])
			"heals":
				attacker["current_health"] += effect["value"]
				attacker["current_health"] = min(attacker["max_health"], attacker["current_health"])
				display_message("%s is healed for %d HP!" % [attacker["animal_name"], effect["value"]])

		# Decrease remaining duration and mark for removal if expired
		if effect["remaining_duration"] > 0:
			effect["remaining_duration"] -= 1
		elif effect["remaining_duration"] == 0:
			effects_to_remove.append(effect)

	# Remove expired effects
	for effect in effects_to_remove:
		active_effects[attacker["animal_name"]].erase(effect)
		print("Effect expired for %s: %s" % [attacker["animal_name"], effect])

	# Log active effects for debugging
	print("Active effects log:")
	for animal in active_effects.keys():
		print("- %s: %s" % [animal, active_effects[animal]])

# Display a message (e.g., for UI or debugging)
func display_message(msg: String) -> void:
	# Replace with actual UI logic as needed
	print(msg)
