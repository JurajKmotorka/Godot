extends Node2D

@export var animal_database_path: String = "res://scripts/animal_database.gd"  # Path to database
@onready var animal_nodes = get_children()  # All child animal nodes

func _ready():
	# Load the animal database
	print("Animal database loaded with animal")
	# Example: Spawn random animals
	for node in animal_nodes:
		spawn_random_animal(node)

func spawn_random_animal(animal_node):
	# Pick a random animal name
	var animal_ids = AnimalDatabase.animals.keys()
	if animal_ids.size() == 0:
		print("No animals available to spawn.")
		return

	var random_id = animal_ids[randi() % animal_ids.size()]
	

	# Send the data to the child node and activate it
	if animal_node.has_method("load_animal_data"):
		animal_node.load_animal_data(random_id)
		animal_node.visible = true
		print("Spawned animal '%s'" % [random_id])
	else:
		print("Child node does not support loading animal data.")
