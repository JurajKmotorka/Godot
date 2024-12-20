extends Node

var animals = {
	1: {
		"animal_name": "Dog",
		"class": "Beast",
		"max_health": 80,
		"current_health": 80,
		"attack_power": 30,
		"defense": 20,
		"speed": 50,
		"sprite_frames": "res://Art/Animals/Spriteframes/Dog.tres",
		"moves": [1, 2, 6],
		"rarity": "common"
	},
	2: {
		"animal_name": "Peacock",
		"class": "Bird",
		"max_health": 60,
		"current_health": 60,
		"attack_power": 25,
		"defense": 15,
		"speed": 70,
		"sprite_frames": "res://Art/Animals/Spriteframes/Peacock.tres",
		"moves": [4, 5, 6],
		"rarity": "uncommon"
	},
	3: {
		"animal_name": "Hippo",
		"class": "Fish",
		"max_health": 120,
		"current_health": 120,
		"attack_power": 20,
		"defense": 50,
		"speed": 25,
		"sprite_frames": "res://Art/Animals/Spriteframes/Hippo.tres",
		"moves": [7, 8],
		"rarity": "rare"
	},
	4: {
		"animal_name": "Uletif",
		"class": "Fish",
		"max_health": 250,
		"current_health": 250,
		"attack_power": 35,
		"defense": 60,
		"speed": 15,
		"sprite_frames": "res://Art/Animals/Spriteframes/Uletif.tres",
		"moves": [9, 10, 14],
		"rarity": "legendary"
	},
	5: {
		"animal_name": "Amphisbaena",
		"class": "Serpent",
		"max_health": 100,
		"current_health": 100,
		"attack_power": 45,
		"defense": 30,
		"speed": 60,
		"sprite_frames": "res://Art/Animals/Spriteframes/Amphisbaena.tres",
		"moves": [11, 12, 15],
		"rarity": "epic"
	},
	6: {
		"animal_name": "Abides",
		"class": "Fish",
		"max_health": 130,
		"current_health": 130,
		"attack_power": 30,
		"defense": 45,
		"speed": 30,
		"sprite_frames": "res://Art/Animals/Spriteframes/Abides.tres",
		"moves": [7, 9, 14],
		"rarity": "epic"
	},
	7: {
		"animal_name": "Snail",
		"class": "Worm",
		"max_health": 60,
		"current_health": 60,
		"attack_power": 15,
		"defense": 100,
		"speed": 10,
		"sprite_frames": "res://Art/Animals/Spriteframes/Snail.tres",
		"moves": [9, 11, 13],
		"rarity": "common"
	},
	8: {
		"animal_name": "Scitalis",
		"class": "Serpent",
		"max_health": 100,
		"current_health": 100,
		"attack_power": 50,
		"defense": 35,
		"speed": 150,
		"sprite_frames": "res://Art/Animals/Spriteframes/Scitalis.tres",
		"moves": [12, 13, 15],
		"rarity": "legendary"
	},
	9: {
		"animal_name": "Cat",
		"class": "Beast",
		"max_health": 90,
		"current_health": 90,
		"attack_power": 40,
		"defense": 20,
		"speed": 120,
		"sprite_frames": "res://Art/Animals/Spriteframes/Cat.tres",
		"moves": [1, 2, 6],
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
