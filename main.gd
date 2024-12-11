extends Node2D

@export var animal_scene_path: String = "res://Characters/SpawnedAnimal.tscn" # Path to the animal scene
@export var animal_database_path: String = "res://scripts/animal_database.gd" # Path to the database

@onready var spawn_points = $SpawnPoints
@onready var animal_container = $AnimalContainer

# List of all animal names in the database
var animal_names = []

func _ready():
	# Load the animal database script
	var animal_database = load(animal_database_path).new()
	
	# Populate the list of animal names
	animal_names = animal_database.animals.keys()
	if animal_names.size() == 0:
		print("Animal database is empty!")
		return
		
	

func spawn_random_animal():
	# Load the animal database script
	var animal_database = load(animal_database_path).new()

	# Pick a random animal name from the database
	var random_name = animal_names[randi() % animal_names.size()]

	# Get the animal data using the name
	var random_animal_data = animal_database.get_animal(random_name)

	# Load the animal scene
	var animal_scene = load(animal_scene_path)
	if animal_scene == null:
		print("Failed to load animal scene: %s" % animal_scene_path)
		return

	# Instance the animal scene
	var animal_instance = animal_scene.instantiate()

	# Assign the animal data to the new instance
	if animal_instance.has_method("set_animal_data"):
		animal_instance.set_animal_data(random_animal_data)

	# Get all spawn points and pick a random one
	var points = spawn_points.get_children()
	if points.size() > 0:
		var random_spawn_index = randi() % points.size()
		var spawn_point = points[random_spawn_index]
		animal_instance.global_position = spawn_point.global_position

		# Add the new animal to the container
		animal_container.add_child(animal_instance)
	else:
		print("No spawn points found.")
