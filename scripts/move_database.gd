extends Node
# Global moves database with additional effects
var moves = {
	"Bite": {"damage": 10, "precision": 90, "type": "offensive", "effect": null},
	"Mucus": {"damage": 5, "precision": 80, "type": "offensive", "effect": null},
	"Bark": {"damage": 0, "precision": 100, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "defense",
		"duration": 0
	}},
	"Slash": {"damage": 20, "precision": 70, "type": "offensive", "effect": null},
	"Roar": {"damage": 0, "precision": 100, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "attack_power",
		"duration": 1
	}},
	"Tackle": {"damage": 15, "precision": 95, "type": "offensive", "effect": null},
	"Tidal Wave": {"damage": 5, "precision": 75, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "attack_power",
	}},
	"Saw": {"damage": 35, "precision": 65, "type": "offensive", "effect": null},
	"Spit": {"damage": 20, "precision": 90, "type": "offensive", "effect": null},
	"Healing Touch": {"damage": 0, "precision": 100, "type": "heals", "effect": {
		"type": "heals",
		"value": 30,
		"duration": 1
	}},
	"Enrage": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "attack_power",
		"duration": 1
	}},
	"Poison": {"damage": 10, "precision": 90, "type": "debuff", "effect": {
		"type": "damage_over_time",
		"value": 5,
		"duration": 3
	}},
	"Stun": {"damage": 0, "precision": 85, "type": "debuff", "effect": {
		"type": "status_effect",
		"status": "stunned",
		"duration": 1
	}},
	"Protective Shield": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "defense",
		"duration": 1
	}},
	"Fireball": {"damage": 30, "precision": 80, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 5,
		"duration": 2
	}},
	"Speed Boost": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "speed",
		"duration": 1
	}},
	"Rabies": {"damage": 5, "precision": 40, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 20,
		"duration": 10
	}},
	"Peck": {"damage": 10, "precision": 40, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 10,
		"duration": 10
	}},
}

func get_move(name: String) -> Dictionary:
	if moves.has(name):
		return moves[name].duplicate(true)
	else:
		print("Move '%s' not found in database" % name)
		return {}
