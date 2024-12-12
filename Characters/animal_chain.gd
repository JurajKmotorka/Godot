extends Node2D

@export var max_following: int = 4  # Maximum number of animals that can follow the player
var following_animals: Array = [1,3,2,4]  # List to store animals that are currently following the player

# Function to spawn all followers based on the following_animals array
func spawn_all_followers() -> void:
	for i in range(following_animals.size()):
		spawn_follower(following_animals[i], i)

# Function to spawn a single animal as a follower
func spawn_follower(animal_id: int, position_index: int) -> void:
	var animal_scene = preload("res://Characters/following_animal.tscn").instantiate()
	
	   
	# Pass the animal data to the spawned animal
	animal_scene.load_animal_id(animal_id)
	
	# Add the spawned animal as a child of the AnimalChain
	add_child(animal_scene)
	
	# Position the animal based on its index in the following array
	var offset = Vector2(-40, 0) * position_index  # Adjust offset to suit your game
	animal_scene.global_position = global_position + offset

	print("Spawned follower with ID %d at position index %d" % [animal_id, position_index])

func _ready():
	# Spawn all followers when the game starts or this node is added to the scene tree
	spawn_all_followers()
