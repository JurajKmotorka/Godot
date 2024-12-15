extends Node
# Global moves database with additional effects
var moves = {
	1: {"move": "Bite", "damage": 25, "precision": 85, "type": "offensive", "effect": null},
	2: {"move": "Bark", "damage": 0, "precision": 100, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "attack",
		"value": 5,
		"duration": 2
	}},
	3: {"move": "Rabies", "damage": 50, "precision": 40, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "attack",
		"value": 10,
		"duration": 3
	}},
	4: {"move": "Slash", "damage": 20, "precision": 70, "type": "offensive", "effect": null},
	5: {"move": "Roar", "damage": 0, "precision": 100, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "attack",
		"value": 8,
		"duration": 2
	}},
	6: {"move": "Tackle", "damage": 15, "precision": 95, "type": "offensive", "effect": null},
	7: {"move": "Tidal Wave", "damage": 5, "precision": 75, "type": "debuff", "effect": {
		"type": "stat_debuff",
		"stat": "attack",
		"value": 3,
		"duration": 1
	}},
	8: {"move": "Saw", "damage": 35, "precision": 65, "type": "offensive", "effect": null},
	9: {"move": "Spit", "damage": 20, "precision": 90, "type": "offensive", "effect": null},
	10: {"move": "Healing Touch", "damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "heals",
		"value": 30
	}},
	11: {"move": "Enrage", "damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "attack",
		"value": 15,
		"duration": 3
	}},
	12: {"move": "Poison", "damage": 10, "precision": 90, "type": "debuff", "effect": {
		"type": "damage_over_time",
		"value": 5,
		"duration": 3
	}},
	13: {"move": "Stun", "damage": 0, "precision": 85, "type": "debuff", "effect": {
		"type": "status_effect",
		"status": "stunned",
		"duration": 1
	}},
	14: {"move": "Protective Shield", "damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "defense",
		"value": 10,
		"duration": 3
	}},
	15: {"move": "Fireball", "damage": 30, "precision": 80, "type": "offensive", "effect": {
		"type": "damage_over_time",
		"value": 5,
		"duration": 2
	}},
	16: {"move": "Speed Boost", "damage": 0, "precision": 100, "type": "buff", "effect": {
		"type": "stat_buff",
		"stat": "speed",
		"value": 10,
		"duration": 2
	}}
}

func get_move(key: int) -> Dictionary:
	if moves.has(key):
		return moves[key].duplicate(true)
	else:
		print("Move with key %s not found in database" % str(key))
		return {}
