extends Node

# Class type interaction multipliers
const CLASS_MULTIPLIERS = {
	"Beast": {"Bird": 0.9, "Serpent": 1.1}, # Beast does less damage to Bird, more to Serpent
	"Bird": {"Serpent": 0.9, "Beast": 1.1}, # Bird does less damage to Serpent, more to Beast
	"Serpent": {"Bird": 1.1, "Beast": 0.9}, # Serpent does more damage to Bird, less to Beast
	"Fish": {"default": {"attack_power": 0.8, "defense": 1.2}}, # Fish has lower attack, higher defense
	"Worm": {}
}

# Function to initialize and scale stats
func initialize_stats(animal_data: Dictionary, level: int, enemy_class: String = "") -> Dictionary:
	# Initialize and scale base stats
	var stats = {
		"animal_name": animal_data.get("animal_name"),
		"level": level,
		"max_health": _scale_stat(animal_data.get("max_health"), level),
		"current_health": _scale_stat(animal_data.get("current_health"), level),
		"attack_power": _scale_stat(animal_data.get("attack_power"), level),
		"defense": _scale_stat(animal_data.get("defense"), level),
		"speed": _scale_stat(animal_data.get("speed"), level),
		"class": animal_data.get("class", "Unknown"),
		"moves": _get_unlocked_moves(animal_data.get("moves", {}), level),
		"sprite_frames": animal_data.get("sprite_frames")
	}

	# Apply class-based multipliers if an enemy class is provided
	_apply_class_modifiers(stats, enemy_class)
	return stats

# Function to get unlocked moves based on level
func _get_unlocked_moves(moves: Dictionary, level: int) -> Array:
	var unlocked_moves = []
	for move_name in moves.keys():
		if level >= moves[move_name]:  # Check if the move's level requirement is met
			unlocked_moves.append(move_name)
	return unlocked_moves

# Function to scale stats based on level
func _scale_stat(base_stat: Array, level: int) -> int:
	# Function to calculate stats based on level
	var growth_rate = float(base_stat[1] - base_stat[0]) / float(100 - 1)  # Ensure floating-point division
	return int(base_stat[0] + growth_rate * (level - 1))

# Function to apply class-based stat modifiers
func _apply_class_modifiers(stats: Dictionary, enemy_class: String) -> void:
	var class_type = stats["class"]
	if class_type in CLASS_MULTIPLIERS:
		var multipliers = CLASS_MULTIPLIERS[class_type]

		# Check for a specific enemy class modifier
		if enemy_class in multipliers:
			stats["attack_power"] = int(stats["attack_power"] * multipliers[enemy_class])
			stats["defense"] = int(stats["defense"] * multipliers[enemy_class])

		# Apply default class modifiers (if no specific enemy class interaction)
		elif "default" in multipliers:
			stats["attack_power"] = int(stats["attack_power"] * multipliers["default"].get("attack_power", 1.0))
			stats["defense"] = int(stats["defense"] * multipliers["default"].get("defense", 1.0))
