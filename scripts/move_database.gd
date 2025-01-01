extends Node
# Global moves database
var moves = {
	#Offensive:
	"Bite": {"damage": 10, "precision": 90, "type": "offensive", "effect": null},
	"Mucus": {"damage": 5, "precision": 80, "type": "offensive", "effect": null},
	"Slash": {"damage": 18, "precision": 70, "type": "offensive", "effect": null},
	"Tackle": {"damage": 22, "precision": 65, "type": "offensive", "effect": null},
	"Saw": {"damage": 35, "precision": 65, "type": "offensive", "effect": null},
	"Spit": {"damage": 12, "precision": 95, "type": "offensive", "effect": null},
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
	
	
	#Debuffs:
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
	
	#Heals
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
	
	#Buffs
	"Protective Shield": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "defense",
		"duration": 1
	}},
	
	"Speed Boost": {"damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "speed",
		"duration": 1
	}},
	
}

func get_move(name: String) -> Dictionary:
	if moves.has(name):
		return moves[name].duplicate(true)
	else:
		print("Move '%s' not found in database" % name)
		return {}
