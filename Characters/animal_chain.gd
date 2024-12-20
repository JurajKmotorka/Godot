extends Node2D

var leader_node: Node2D # Reference to the leader (player or NPC)
var position_queue = []  # Tracks the leader's movement
var max_queue_size = 100  # Max number of positions to track
var previous_position: Vector2 # To track the leader's previous position

# Hardcoded list of animal IDs for the chain
var animal_ids = AnimalDeck.get_selected_animals()
var max_followers = 4  # Maximum number of followers
@export var follower_delay = 20  # Delay steps between each follower

# Called to set up the AnimalChain with a leader
func set_leader(leader: Node2D):
	leader_node = leader

func _ready():
	leader_node = get_parent().get_node("Player")
	if not leader_node:
		print("Leader node is not set. Ensure to call set_leader() before starting.")
		return

	# Ensure the number of followers doesn't exceed the available animal IDs
	var follower_count = min(animal_ids.size(), max_followers)

	# Dynamically generate followers based on animal IDs
	for i in range(follower_count):
		var follower = preload("res://Characters/following_animal.tscn").instantiate()
		add_child(follower)
		
		# Configure the follower
		follower.set_position_queue(position_queue, (i + 1) * follower_delay)
		
		# Send the animal ID to the follower to load sprite data
		follower.set_animal_data(animal_ids[i])

func _process(delta):
	if leader_node:
		# Check if the leader has moved
		if leader_node.global_position != previous_position:
			# If the leader has moved, update the position queue
			position_queue.append(leader_node.global_position)
			
			# Ensure the queue does not exceed the max size
			if position_queue.size() > max_queue_size:
				position_queue.pop_front()
			
			# Update the previous position to the current one
			previous_position = leader_node.global_position
