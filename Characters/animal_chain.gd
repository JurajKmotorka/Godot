extends Node2D

@export var max_following: int = 4
var following_animals: Array = [2, 1, 6, 7]  # Animal IDs to spawn
var follower_nodes: Array = []  # Spawned follower nodes

@export var min_distance: float = 50.0  # Minimum distance between followers
@export var max_distance: float = 80.0  # Maximum distance before speed is increased
@export var move_speed: float = 200.0  # Base movement speed of followers
@export var smoothing_factor: float = 2  # Smoothing for movement to reduce jittering
@export var buffer_zone: float = 10.0  # Buffer zone around the target position

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

	# Position the follower behind the player or the previous follower
	if follower_nodes.is_empty():
		# Place first follower behind the player
		animal_scene.global_position = player.global_position - Vector2(min_distance, 0)
	else:
		# Place subsequent followers behind the last follower
		var last_follower = follower_nodes[follower_nodes.size() - 1]
		animal_scene.global_position = last_follower.global_position - Vector2(min_distance, 0)

	# Add the new follower to the list
	follower_nodes.append(animal_scene)

func _process(delta: float) -> void:
	if not player or follower_nodes.is_empty():
		return

	# Update the position of each follower
	for i in range(follower_nodes.size()):
		var follower = follower_nodes[i]
		var leader_position: Vector2

		if i == 0:
			# The first follower follows the player
			leader_position = player.global_position
		else:
			# Subsequent followers follow the previous follower
			var previous_follower = follower_nodes[i - 1]
			leader_position = previous_follower.global_position

		# Calculate the distance to the leader
		var current_distance = follower.global_position.distance_to(leader_position)

		# Apply buffer zone logic
		if current_distance > min_distance + buffer_zone:
			# Move towards the leader if outside the buffer zone
			var direction = (leader_position - follower.global_position).normalized()
			var speed_factor = lerp(0.0, move_speed, (current_distance - min_distance) / (max_distance - min_distance))
			follower.global_position += direction * speed_factor * delta
		elif current_distance < min_distance:
			# Move slightly away to maintain minimum distance
			var direction = (follower.global_position - leader_position).normalized()
			follower.global_position = leader_position + direction * min_distance

		# Apply smoothing to prevent jittering using lerp
		follower.global_position = lerp(follower.global_position, leader_position, smoothing_factor * delta)
		
	
