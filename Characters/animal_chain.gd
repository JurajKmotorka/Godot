extends Node2D

var leader_node: Node2D  # Reference to the leader (player or NPC)
var position_queue = []  # Tracks the leader's movement
var max_queue_size = 100  # Max number of positions to track
var previous_position: Vector2 = Vector2.ZERO  # To track the leader's previous position
var movement_threshold: float = 1.0  # Minimum distance to consider as movement

# Fetch selected animals from the AnimalDeck
var selected_animals = AnimalDeck.get_selected_animals()  # Dictionary with {UID: {id, level, xp}}
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

	# Limit the number of followers to the available selected animals
	var follower_count = min(selected_animals.size(), max_followers)

	# Dynamically generate followers based on selected animals
	var uids = selected_animals.keys()  # Get the UIDs of selected animals
	var i = 0
	for uid in uids:
		if i >= follower_count:
			break
		
		# Instantiate and add a follower
		var follower = preload("res://Characters/following_animal.tscn").instantiate()
		add_child(follower)
		
		# Configure the follower
		follower.set_position_queue(position_queue, (i + 1) * follower_delay)
		
		# Send the animal ID to the follower to load sprite data
		follower.set_animal_data(selected_animals[uid]["id"])
		
		i += 1

func _process(delta):
	if leader_node:
		# Calculate the distance moved since the last frame
		var distance_moved = leader_node.global_position.distance_to(previous_position)
		
		# Update the queue only if the movement exceeds the threshold
		if distance_moved > movement_threshold:
			position_queue.append(leader_node.global_position)
			
			# Ensure the queue does not exceed the max size
			if position_queue.size() > max_queue_size:
				position_queue.pop_front()
			
			# Update the previous position to the current one
			previous_position = leader_node.global_position
