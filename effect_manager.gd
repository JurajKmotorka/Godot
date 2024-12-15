extends Node

# Holds a list of currently applied effects to animals
var active_effects = {}

# Apply an effect to a target animal
func apply_effect(effect: Dictionary, target: Dictionary) -> void:
	# Check if the effect is null or doesn't exist
	if effect == null or not effect.has("effect") or effect["effect"] == null:
		# If no effect is provided, skip it
		print("No effect to apply for this move.")
		return
	
	# Create an entry for the effect if it doesn't exist
	if not active_effects.has(target["animal_name"]):
		active_effects[target["animal_name"]] = []

	# Add the effect to the animal's list of active effects
	active_effects[target["animal_name"]].append(effect)

	# Apply immediate effect (e.g., instant damage or stat change)
	if effect.has("immediate_effect"):
		apply_immediate_effect(effect, target)

	# If the effect is persistent (e.g., poison, burn), set up the effect timer
	if effect.has("duration") and effect["duration"] > 0:
		# Store effect duration in the target dictionary (instead of using set_meta)
		target["effect_duration"] = effect["duration"]

# Resolve and apply ongoing effects
func resolve_effects(target: Dictionary) -> void:
	if not active_effects.has(target["animal_name"]):
		return

	var effects_to_remove = []

	# Go through each active effect and apply it
	for effect in active_effects[target["animal_name"]]:
		# Apply the ongoing effects (e.g., poison or burn)
		if effect["type"] == "damage_over_time":
			apply_damage_over_time(effect, target)

		# Check for effect expiration and remove effects as necessary
		if effect.has("duration"):
			# Decrease the duration
			target["effect_duration"] -= 1
			if target["effect_duration"] <= 0:
				effects_to_remove.append(effect)

	# Remove expired effects
	for effect in effects_to_remove:
		active_effects[target["animal_name"]].erase(effect)

# Apply immediate effects (one-time effects such as stat changes or instant damage)
func apply_immediate_effect(effect: Dictionary, target: Dictionary) -> void:
	if effect["immediate_effect"] == "damage":
		target["current_health"] -= effect["value"]
	elif effect["immediate_effect"] == "stat_boost":
		apply_stat_boost(effect, target)

# Apply damage over time (e.g., poison, burn)
func apply_damage_over_time(effect: Dictionary, target: Dictionary) -> void:
	if effect["type"] == "damage_over_time":
		target["current_health"] -= effect["value"]
		display_message("%s is affected by %s and takes %d damage!" % [target["animal_name"], effect["name"], effect["value"]])

# Apply stat boost (temporary increase in stats)
func apply_stat_boost(effect: Dictionary, target: Dictionary) -> void:
	if effect["stat_type"] == "attack":
		target["attack"] += effect["value"]
	elif effect["stat_type"] == "defense":
		target["defense"] += effect["value"]
	elif effect["stat_type"] == "speed":
		target["speed"] += effect["value"]
	
	# Remove the boost after the effect expires
	if effect.has("duration"):
		target["stat_boost_duration"] = effect["duration"]

# Resolve stat boosts (end them when the duration expires)
func resolve_stat_boosts(target: Dictionary) -> void:
	if target.has("stat_boost_duration") and target["stat_boost_duration"] <= 0:
		# Reset the stat to its original value
		apply_stat_boost_reset(target)
		target.erase("stat_boost_duration")

# Reset stats to their original values after a stat boost expires
func apply_stat_boost_reset(target: Dictionary) -> void:
	for effect in active_effects.get(target["animal_name"], []):
		if effect.has("stat_boost"):
			if effect["stat_type"] == "attack":
				target["attack"] -= effect["value"]
			elif effect["stat_type"] == "defense":
				target["defense"] -= effect["value"]
			elif effect["stat_type"] == "speed":
				target["speed"] -= effect["value"]

# Display messages for ongoing effects
func display_message(msg: String) -> void:
	# Here, you would call the UI manager to show the message
	print(msg)
