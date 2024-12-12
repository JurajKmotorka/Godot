extends Node2D

@export var spawn_positions: Array = []  # Predefined spawn positions
@onready var animal_pool = $SpawnPoints  # Group or parent node containing hidden animal scenes

func _ready():
	print("Main script ready!")
	

func spawn_animal(position_index: int, animal_id: int):
	# Check if the position index is valid
	if position_index >= spawn_positions.size():
		print("Invalid spawn position index: %s" % position_index)
		return
	
	# Get the spawn position
	var spawn_position = spawn_positions[position_index]

	# Find the corresponding hidden animal scene in the pool
	for animal_scene in animal_pool.get_children():
		if animal_scene.get("animal_id") == animal_id:
			# Activate the animal and set its position
			animal_scene.visible = true
			animal_scene.global_position = position
			print("Spawned animal ID %s at position %s" % [animal_id, position])
			return

	print("No matching animal found for ID: %s" % animal_id)
