extends Node

# Animal database as a single dictionary
var animals = {
	1: {
		"animal_name": "Dog",  # Renamed 'animal' to 'animal_name'
		"class": "Beast",
		"max_health": 150,
		"current_health": 150,
		"attack_power": 35,
		"sprite_frames": "res://Art/Animals/Spriteframes/Dog.tres",
		"moves": [
			{"move": "Bite", "damage": 25, "precision": 85, "type": "offensive", "effect": null},
			{"move": "Bark", "damage": 0, "precision": 100, "type": "debuff", "effect": "lowers_attack"},
			{"move": "Rabies", "damage": 50, "precision": 40, "type": "debuff", "effect": "lowers_attack"}
		],
	},
	2: {
		"animal_name": "Peacock",  # Renamed 'animal' to 'animal_name'
		"class": "Bird",
		"max_health": 75,
		"current_health": 75,
		"attack_power": 25,
		"sprite_frames": "res://Art/Animals/Spriteframes/Peacock.tres",
		"moves": [
			{"move": "Slash", "damage": 20, "precision": 70, "type": "offensive", "effect": null},
			{"move": "Roar", "damage": 0, "precision": 100, "type": "debuff", "effect": "lowers_attack"},
			{"move": "Tackle", "damage": 15, "precision": 95, "type": "offensive", "effect": null}
		],
	},
	3: {
		"animal_name": "Hippo",  # Renamed 'animal' to 'animal_name'
		"class": "Fish",
		"max_health": 200,
		"current_health": 200,
		"attack_power": 20,
		"sprite_frames": "res://Art/Animals/Spriteframes/Hippo.tres",
		"moves": [
			{"move": "Tidal Wave", "damage": 5, "precision": 75, "type": "special", "effect": "lowers_attack"},
			{"move": "Bite", "damage": 15, "precision": 90, "type": "offensive", "effect": null}
		],
	},
	4: {
		"animal_name": "Uletif",  # Renamed 'animal' to 'animal_name'
		"class": "Fish",
		"max_health": 300,
		"current_health": 300,
		"attack_power": 30,
		"sprite_frames": "res://Art/Animals/Spriteframes/Uletif.tres",
		"moves": [
			{"move": "Saw", "damage": 35, "precision": 65, "type": "offensive", "effect": null},
			{"move": "Bite", "damage": 25, "precision": 90, "type": "offensive", "effect": null}
		],
	},
	5: {
		"animal_name": "Amphisbaena",  # Renamed 'animal' to 'animal_name'
		"class": "Serpent",
		"max_health": 200,
		"current_health": 200,
		"attack_power": 40,
		"sprite_frames": "res://Art/Animals/Spriteframes/Amphisbaena.tres",
		"moves": [
			{"move": "Bite", "damage": 25, "precision": 65, "type": "offensive", "effect": null},
			{"move": "Spit", "damage": 20, "precision": 90, "type": "offensive", "effect": null}
		],
	},
}

# Function to add an animal to the database
func _add_animal(animal_data: Dictionary) -> void:
	if animal_data.has("animal_name"):  # Adjusted to check for 'animal_name'
		var key = animal_data["animal_name"].to_lower()  # Use 'animal_name' instead of 'name'
		animals[key] = animal_data
		print("Added animal: %s" % animal_data["animal_name"])  # Adjusted to print 'animal_name'
	else:
		print("Animal data must have an 'animal_name' field")

# Function to retrieve an animal by name (using animal name as the key)
func get_animal(key: int) -> Dictionary:
	if animals.has(key):
		return animals[key].duplicate(true)  # Return a copy to avoid modifying the original
	else:
		print("Animal with key %s not found in database" % str(key))  # Adjusted error message
		return {}

# Debugging: Print all animals in the database
func print_all_animals() -> void:
	for key in animals.keys():
		print("Animal: %s, Data: %s" % [animals[key]["animal_name"].capitalize(), animals[key]])  # Adjusted to use 'animal_name'
