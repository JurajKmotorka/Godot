extends Node

# Class type interaction multipliers
const CLASS_MULTIPLIERS = {
	"Beast": {"Bird": 0.9, "Serpent": 1.1}, # Beast does less damage to Bird, more to Serpent
	"Bird": {"Serpent": 0.9, "Beast": 1.1}, # Bird does less damage to Serpent, more to Beast
	"Serpent": {"Bird": 1.1, "Beast": 0.9}, # Serpent does more damage to Bird, less to Beast
	"Fish": {"default": {"attack_power": 0.8, "defense": 1.2}}, # Fish has lower attack, higher defense
	"Worm": {}
}

# Stat growth multipliers per level
const STAT_GROWTH = {
	"max_health": 20,    # +10 health per level
	"attack_power": 10,   # +2 attack power per level
	"defense": 2,        # +1 defense per level
	"speed": 2        # +0.5 speed per level
}

func initialize_stats(animal_data: Dictionary, level: int = 1, enemy_class: String = "") -> Dictionary:
	# Initialize and scale base stats
	var stats = {
		"animal_name": animal_data.get("animal_name"),
		"level": level,
		"max_health": _scale_stat(animal_data.get("max_health", 100), level, STAT_GROWTH["max_health"]),
		"attack_power": _scale_stat(animal_data.get("attack", 10), level, STAT_GROWTH["attack_power"]),
		"defense": _scale_stat(animal_data.get("defense", 5), level, STAT_GROWTH["defense"]),
		"speed": _scale_stat(animal_data.get("speed", 10), level, STAT_GROWTH["speed"]),
		"current_health": 0, # Will be set to max_health
		"class": animal_data.get("class", "Unknown"),
		"moves": animal_data.get("moves", []),
		"sprite_frames": animal_data.get("sprite_frames")
	}
	stats["current_health"] = stats["max_health"]

	# Apply class-based multipliers if an enemy class is provided
	_apply_class_modifiers(stats, enemy_class)
	return stats

func _scale_stat(base_stat: int, level: int, growth: float) -> int:
	# Scaling formula for stats
	return base_stat + int(base_stat * (level -1) * growth / 100)

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
