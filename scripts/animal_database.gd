extends Node


# Animal database as a single dictionary
var animals = {
	1: {
		"name": "Dog",
		"class": "Beast",
		"max_health": 150,
		"current_health": 150,
		"attack_power": 35,
		"sprite_frames": "res://Art/Animals/Spriteframes/Dog.tres",

		"moves": [
			{"name": "Bite", "damage": 25, "precision": 85, "type": "offensive", "effect": null},
			{"name": "Bark", "damage": 0, "precision": 100, "type": "debuff", "effect": "lowers_attack"},
			{"name": "Rabies", "damage": 50, "precision": 40, "type": "debuff", "effect": "lowers_attack"}
		],
	},
	2: {
		"name": "Peacock",
		"class": "Bird",
		"max_health": 75,
		"current_health": 75,
		"attack_power": 25,
		"moves": [
			{"name": "Slash", "damage": 20, "precision": 70, "type": "offensive", "effect": null},
			{"name": "Roar", "damage": 0, "precision": 100, "type": "debuff", "effect": "lowers_attack"},
			{"name": "Tackle", "damage": 15, "precision": 95, "type": "offensive", "effect": null}
		],
	},
	3: {
		"name": "Hippo",
		"class": "Fish",
		"max_health": 200,
		"current_health": 200,
		"attack_power": 20,
		"sprite_frames": "res://Art/Animals/Spriteframes/Hippo.tres",
		"moves": [
			{"name": "Tidal Wave", "damage": 5, "precision": 75, "type": "special", "effect": "lowers_attack"},
			{"name": "Bite", "damage": 15, "precision": 90, "type": "offensive", "effect": null}
		],
	},
	4: {
		"name": "Uletif",
		"class": "Fish",
		"max_health": 300,
		"current_health": 300,
		"attack_power": 30,
		"sprite_frames": "res://Art/Animals/Spriteframes/Uletif.tres",
		"moves": [
			{"name": "Saw", "damage": 35, "precision": 65, "type": "offensive", "effect": null},
			{"name": "Bite", "damage": 25, "precision": 90, "type": "offensive", "effect": null}
		],
	},
}

# Function to add an animal to the database
func _add_animal(animal_data: Dictionary) -> void:
	if animal_data.has("name"):
		var key = animal_data["name"].to_lower()
		animals[key] = animal_data
		print("Added animal: %s" % animal_data["name"])
	else:
		print("Animal data must have a 'name' field")

# Function to retrieve an animal by name
func get_animal(name: int) -> Dictionary:
	if animals.has(name):
		return animals[name].duplicate(true)  # Return a copy to avoid modifying the original
	else:
		print("Animal '%s' not found in database" % name)
		return {}

# Debugging: Print all animals in the database
func print_all_animals() -> void:
	for key in animals.keys():
		print("Animal: %s, Data: %s" % [key.capitalize(), animals[key]])
