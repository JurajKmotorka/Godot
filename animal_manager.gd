extends Node2D

@export var animal_database_path: String = "res://scripts/animal_database.gd"  # Path to database
@onready var animal_nodes = get_children()  # All child animal nodes
var animal_database

func _ready():
	# Load the animal database
	animal_database = load(animal_database_path).new()
	if not animal_database or animal_database.animals.size() == 0:
		print("Animal database is empty or failed to load!")
		return

	print("Animal database loaded with animal")
	# Example: Spawn random animals
	for node in animal_nodes:
		spawn_random_animal(node)

func spawn_random_animal(animal_node):
	# Pick a random animal name
	var animal_names = animal_database.animals.keys()
	if animal_names.size() == 0:
		print("No animals available to spawn.")
		return

	var random_name = animal_names[randi() % animal_names.size()]
	var animal_data = animal_database.get_animal(random_name)
	if not animal_data:
		print("Failed to retrieve data for animal: %s" % random_name)
		return

	# Send the data to the child node and activate it
	if animal_node.has_method("load_animal_data"):
		animal_node.load_animal_data(random_name, animal_data)
		animal_node.visible = true
		print("Spawned animal '%s' with data: %s" % [random_name, animal_data])
	else:
		print("Child node does not support loading animal data.")
