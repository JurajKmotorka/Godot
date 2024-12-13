extends Node2D

@export var max_following: int = 4
var following_animals: Array = [1, 3, 2, 4]  # Animal IDs to spawn
var follower_nodes: Array = []  # Spawned follower nodes
var trails: Array = []  # Stores positions for the trail system

@export var trail_length: int = 50  # How many positions to store in the trail
@export var trail_spacing: int = 10  # Spacing between follower positions in the trail (in indices)

var player: Node2D = null  # Reference to the Player node

func _ready() -> void:
	# Find the player node dynamically
	player = get_parent().get_node("Player")
	if not player:
		print("Error: Player node not found!")
		return

	spawn_all_followers()

func spawn_all_followers() -> void:
	# Spawn all follower animals
	for animal_id in following_animals:
		spawn_follower(animal_id)

func spawn_follower(animal_id: int) -> void:
	# Load and instantiate the animal scene
	var animal_scene = preload("res://Characters/following_animal.tscn").instantiate()
	animal_scene.load_animal_id(animal_id)
	add_child(animal_scene)

	# Position the follower behind the previous follower or player
	if follower_nodes.is_empty():
		# Place first follower behind the player
		animal_scene.global_position = player.global_position - Vector2(20, 0)
	else:
		# Place subsequent followers relative to the last one
		var last_follower = follower_nodes[follower_nodes.size() - 1]
		animal_scene.global_position = last_follower.global_position - Vector2(20, 0)

	# Add the new follower to the list
	follower_nodes.append(animal_scene)

func _process(delta: float) -> void:
	if not player or follower_nodes.is_empty():
		return

	# Update the trail with the player's position
	trails.append(player.global_position)
	if trails.size() > trail_length:
		trails.pop_front()

	# Move each follower along the trail
	for i in range(follower_nodes.size()):
		var follower = follower_nodes[i]
		var trail_index = (i + 1) * trail_spacing

		# If there is enough trail data, move the follower
		if trail_index < trails.size():
			follower.global_position = trails[trail_index]
		else:
			# If not enough trail data, place the follower behind the previous one
			if i > 0:
				var previous_follower = follower_nodes[i - 1]
				follower.global_position = previous_follower.global_position - Vector2(20, 0)
