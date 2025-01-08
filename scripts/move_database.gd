extends Node
# Global moves database


var moves = {
	# Offensive Moves
	"Bite": {"damage": 10, "precision": 90, "type": "offensive", "effect": null},
	"Scratch": {"damage": 9, "precision": 100, "type": "offensive", "effect": null},
	"Maul": {"damage": 30, "precision": 75, "type": "offensive", "effect": null},
	"Mucus": {"damage": 5, "precision": 100, "type": "offensive", "effect": null},
	"Slash": {"damage": 18, "precision": 70, "type": "offensive", "effect": null},
	"Tackle": {"damage": 22, "precision": 65, "type": "offensive", "effect": null},
	"Chomp": {"damage": 20, "precision": 72, "type": "offensive", "effect": null},
	"Saw": {"damage": 35, "precision": 65, "type": "offensive", "effect": null},
	"Spit": {"damage": 12, "precision": 95, "type": "offensive", "effect": null},
	"Radulla": {"damage": 22, "precision": 100, "type": "offensive", "effect": null},

	"Fireball": {"damage": 30, "precision": 80, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 5,
		"duration": 2
	}},
	"Rabies": {"damage": 0, "precision": 40, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 10,
		"duration": 100
	}},
	"Peck": {"damage": 15, "precision": 60, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 8,
		"duration": 10
	}},
	"Fury Peck": {"damage": 32, "precision": 80, "type": "offensive", "effect": {
	"type": "damage_over_time",
	"value": 10,
	"duration": 3
}},
	"Claw Swipe": {"damage": 20, "precision": 85, "type": "offensive", "effect": null},
	"Tail Whip": {"damage": 10, "precision": 90, "type": "offensive", "effect": {
		"type": "stat_debuff",
		"stat": "defense",
		"duration": 0
	}},
	"Stealth Strike": {"damage": 24, "precision": 98, "type": "offensive", "effect": {
		"type": "stat_buff",
		"stat": "speed",
		"duration": 0,
		}},
	"Hydro Slash": {"damage": 20, "precision": 90, "type": "offensive", "effect": {
		"type": "stat_debuff",
		"stat": "speed",
		"duration": 0
	}},
	"Venomous Bite": {"damage": 15, "precision": 80, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 8,
		"duration": 100
	}},
	"Poison Strike": {"damage": 33, "precision": 80, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 18,
		"duration": 4
	}},
	"Pierce": {"damage": 25, "precision": 75, "type": "offensive", "effect": null},
	"Trample": {"damage": 35, "precision": 70, "type": "offensive", "effect": null},
	"Aquatic Slam": {"damage": 24, "precision": 85, "type": "offensive", "effect": null},
	"Lightning Strike": {"damage": 35, "precision": 60, "type": "offensive", "effect": null},
	"Bone Breaker": {"damage": 25, "precision": 70, "type": "offensive", "effect": {
	"type": "stat_debuff",
	"value": 10,
	"duration": 0,
	"stat": "defense"
	}},

	"Earthquake": {"damage": 40, "precision": 55, "type": "offensive", "effect": {
		"type": "stat_debuff",
		"stats": ["defense", "speed"],
		"duration": 0
	}},
	"Blizzard": {"damage": 45, "precision": 50, "type": "offensive", "effect": {
		"type": "stat_debuff",
		"stats": ["attack_power", "speed"],
		"duration": 0
	}},
	"Flamethrower": {"damage": 50, "precision": 70, "type": "offensive", "effect": null},

	# Debuff Moves
	"Bark": {"damage": 0, "precision": 100, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "defense",
		"duration": 0
	}},
	"Roar": {"damage": 0, "precision": 100, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "attack_power",
		"duration": 0
	}},
	"Tidal Wave": {"damage": 0, "precision": 75, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stats": ["attack_power", "defense", "speed"],
		"duration": 0
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
	"Frostbite": {"damage": 15, "precision": 80, "type": "debuff", "effect": {
		"type": "damage_over_time",
		"value": 3,
		"duration": 3
	}},

	# Buff Moves
	"Enrage": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "attack_power",
		"duration": 0
	}},
	"Howl": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "attack_power",
		"duration": 0
	}},
	"Purr": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "attack_power",
		"duration": 0
	}},
	"Protective Shield": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "defense",
		"duration": 0
	}},
	"Quick Reflexes": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "speed",
		"duration": 0
	}},
	"Fortify": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stats": ["defense", "attack_power"],
		"duration": 0
	}},
	"Shell Defense": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stats": ["defense"],
		"duration": 0
	}},
	"Tail Feathers": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stats": ["speed", "attack_power"],
		"duration": 0
	}},
	"Water Shield": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stats": ["speed", "defense"],
		"duration": 0
	}},
	"Glitter": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stats": ["speed", "defense", "attack_power"],
		"duration": 0
	}},

	# Healing Moves
	"Healing Touch": {"damage": 0, "precision": 100, "type": "heal", "effect": {
		"type": "heal",
		"value": 30,
		"duration": 1
	}},
	"Regenerate": {"damage": 0, "precision": 100, "type": "heal", "effect": {
		"type": "heal",
		"value": 10,
		"duration": 3
	}},
	"Restoration": {"damage": 0, "precision": 100, "type": "heal", "effect": {
		"type": "heal",
		"value": 50,
		"duration": 1
	}},
}


func get_move(name: String) -> Dictionary:
	if moves.has(name):
		return moves[name].duplicate(true)
	else:
		print("Move '%s' not found in database" % name)
		return {}
