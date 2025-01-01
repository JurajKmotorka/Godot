extends Node

var animals = {
	1: {
		"animal_name": "Dog",
		"class": "Beast",
		"max_health": [20, 200], # 10x scaling
		"current_health": [20, 200],
		"attack_power": [5, 50],
		"defense": [8, 80],
		"speed": [10, 100],
		"sprite_frames": "res://Art/Animals/Spriteframes/Dog.tres",
		"moves": {"Bite": 1, "Bark": 1, "Rabies": 20},
		"rarity": "common"
	},
	2: {
		"animal_name": "Peacock",
		"class": "Bird",
		"max_health": [14, 143], # 10.2x scaling
		"current_health": [14, 143],
		"attack_power": [6, 61], 
		"defense": [6, 61],
		"speed": [12, 122],
		"sprite_frames": "res://Art/Animals/Spriteframes/Peacock.tres",
		"moves": {"Bite": 1, "Peck": 1},
		"rarity": "uncommon"
	},
	3: {
		"animal_name": "Hippo",
		"class": "Fish",
		"max_health": [22, 233], # 10.6x scaling
		"current_health": [22, 233],
		"attack_power": [6, 64],
		"defense": [10, 106],
		"speed": [8, 85],
		"sprite_frames": "res://Art/Animals/Spriteframes/Hippo.tres",
		"moves": {"Bite": 1, "Enrage": 1},
		"rarity": "rare"
	},
	4: {
		"animal_name": "Uletif",
		"class": "Fish",
		"max_health": [25, 300], # 12x scaling
		"current_health": [25, 300],
		"attack_power": [7, 84],
		"defense": [11, 132],
		"speed": [9, 108],
		"sprite_frames": "res://Art/Animals/Spriteframes/Uletif.tres",
		"moves": {"Bite": 1, "Saw": 8},
		"rarity": "legendary"
	},
	5: {
		"animal_name": "Amphisbaena",
		"class": "Serpent",
		"max_health": [20, 224], # 11.2x scaling
		"current_health": [20, 224],
		"attack_power": [8, 90],
		"defense": [9, 101],
		"speed": [10, 112],
		"sprite_frames": "res://Art/Animals/Spriteframes/Amphisbaena.tres",
		"moves": {"Bite": 1, "Slash": 5},
		"rarity": "epic"
	},
	6: {
		"animal_name": "Abides",
		"class": "Fish",
		"max_health": [20, 224], # 11.2x scaling
		"current_health": [20, 224],
		"attack_power": [6, 67],
		"defense": [10, 112],
		"speed": [9, 101],
		"sprite_frames": "res://Art/Animals/Spriteframes/Abides.tres",
		"moves": {"Bite": 1},
		"rarity": "epic"
	},
	7: {
		"animal_name": "Snail",
		"class": "Worm",
		"max_health": [12, 120], # 10x scaling
		"current_health": [12, 120],
		"attack_power": [3, 30],
		"defense": [15, 150],
		"speed": [4, 40],
		"sprite_frames": "res://Art/Animals/Spriteframes/Snail.tres",
		"moves": {"Mucus": 1},
		"rarity": "common"
	},
	8: {
		"animal_name": "Scitalis",
		"class": "Serpent",
		"max_health": [20, 240], # 12x scaling
		"current_health": [20, 240],
		"attack_power": [9, 108],
		"defense": [10, 120],
		"speed": [12, 144],
		"sprite_frames": "res://Art/Animals/Spriteframes/Scitalis.tres",
		"moves": {"Bite": 1, "Slash": 5},
		"rarity": "legendary"
	},
	9: {
		"animal_name": "Cat",
		"class": "Beast",
		"max_health": [18, 180], # 10x scaling
		"current_health": [18, 180],
		"attack_power": [5, 50],
		"defense": [7, 70],
		"speed": [14, 140],
		"sprite_frames": "res://Art/Animals/Spriteframes/Cat.tres",
		"moves": {"Bite": 1},
		"rarity": "common"
	},
	10: {
		"animal_name": "Turtle",
		"class": "Fish",
		"max_health": [22, 244], # 11.1x scaling
		"current_health": [22,244],
		"attack_power": [5, 56],
		"defense": [10, 112],
		"speed": [7, 81],
		"sprite_frames": "res://Art/Animals/Spriteframes/Turtle.tres",
		"moves": {"Bite": 1},
		"rarity": "rare"
	},
	11: {
		"animal_name": "Goat",
		"class": "beast",
		"max_health": [17, 170], # 11.1x scaling
		"current_health": [17,170],
		"attack_power": [7, 70],
		"defense": [5, 50],
		"speed": [14, 140],
		"sprite_frames": "res://Art/Animals/Spriteframes/Goat.tres",
		"moves": {"Bite": 1, "Tackle": 10},
		"rarity": "common"
	},
	12: {
		"animal_name": "Owl",
		"class": "bird",
		"max_health": [12, 120], # 11x scaling
		"current_health": [12,130],
		"attack_power": [9, 100],
		"defense": [5, 50],
		"speed": [16, 170],
		"sprite_frames": "res://Art/Animals/Spriteframes/Owl.tres",
		"moves": {"Bite": 1},
		"rarity": "uncommon"
	},
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
