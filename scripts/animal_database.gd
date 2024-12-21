extends Node

var animals = {
	1: {
		"animal_name": "Dog",
		"class": "Beast",
		"max_health": 20,
		"current_health": 20,
		"attack_power": 5,
		"defense": 10,
		"speed": 10,
		"sprite_frames": "res://Art/Animals/Spriteframes/Dog.tres",
		"moves": [1,3],
		"rarity": "common"
	},
	2: {
		"animal_name": "Peacock",
		"class": "Bird",
		"max_health": 16,
		"current_health": 16,
		"attack_power": 10,
		"defense": 7,
		"speed": 15,
		"sprite_frames": "res://Art/Animals/Spriteframes/Peacock.tres",
		"moves": [1],
		"rarity": "uncommon"
	},
	3: {
		"animal_name": "Hippo",
		"class": "Fish",
		"max_health": 25,
		"current_health": 25,
		"attack_power": 10,
		"defense": 15,
		"speed": 5,
		"sprite_frames": "res://Art/Animals/Spriteframes/Hippo.tres",
		"moves": [1, 11],
		"rarity": "rare"
	},
	4: {
		"animal_name": "Uletif",
		"class": "Fish",
		"max_health": 32,
		"current_health": 32,
		"attack_power": 20,
		"defense": 18,
		"speed": 15,
		"sprite_frames": "res://Art/Animals/Spriteframes/Uletif.tres",
		"moves": [1],
		"rarity": "legendary"
	},
	5: {
		"animal_name": "Amphisbaena",
		"class": "Serpent",
		"max_health": 14,
		"current_health": 14,
		"attack_power": 25,
		"defense": 10,
		"speed": 14,
		"sprite_frames": "res://Art/Animals/Spriteframes/Amphisbaena.tres",
		"moves": [1],
		"rarity": "epic"
	},
	6: {
		"animal_name": "Abides",
		"class": "Fish",
		"max_health": 18,
		"current_health": 18,
		"attack_power": 18,
		"defense": 20,
		"speed": 10,
		"sprite_frames": "res://Art/Animals/Spriteframes/Abides.tres",
		"moves": [1],
		"rarity": "epic"
	},
	7: {
		"animal_name": "Snail",
		"class": "Worm",
		"max_health": 5,
		"current_health": 5,
		"attack_power": 5,
		"defense": 50,
		"speed": 1,
		"sprite_frames": "res://Art/Animals/Spriteframes/Snail.tres",
		"moves": [2],
		"rarity": "common"
	},
	8: {
		"animal_name": "Scitalis",
		"class": "Serpent",
		"max_health": 16,
		"current_health": 16,
		"attack_power": 40,
		"defense": 13,
		"speed": 21,
		"sprite_frames": "res://Art/Animals/Spriteframes/Scitalis.tres",
		"moves": [1],
		"rarity": "legendary"
	},
	9: {
		"animal_name": "Cat",
		"class": "Beast",
		"max_health": 12,
		"current_health": 12,
		"attack_power": 11,
		"defense": 8,
		"speed": 20,
		"sprite_frames": "res://Art/Animals/Spriteframes/Cat.tres",
		"moves": [1],
		"rarity": "common"
	}
}



# Function to add an animal to the database
func _add_animal(animal_data: Dictionary) -> void:
	if animal_data.has("animal_name"):
		var key = animal_data["animal_name"].to_lower()
		animals[key] = animal_data
		print("Added animal: %s" % animal_data["animal_name"])
	else:
		print("Animal data must have an 'animal_name' field")

# Function to retrieve an animal by ID
func get_animal(key: int) -> Dictionary:
	if animals.has(key):
		return animals[key].duplicate(true)
	else:
		print("Animal with key %s not found in database" % str(key))
		return {}

# Debugging: Print all animals in the database
func print_all_animals() -> void:
	for key in animals.keys():
		print("Animal: %s, Data: %s" % [animals[key]["animal_name"].capitalize(), animals[key]])
