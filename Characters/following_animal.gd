extends Node2D

var animal_data: Dictionary  # Animal data for sprites, stats, etc.
var position_queue = []  # Reference to the position queue in AnimalChain
var delay_steps: int = 0  # Delay in queue steps for following
var is_moving: bool = false  # Track if the player is moving

# Called by AnimalChain to set the position queue and delay
func set_position_queue(queue: Array, delay: int) -> void:
	position_queue = queue
	delay_steps = delay

# Loads animal data and sets up its properties
func set_animal_data(id: int) -> void:
	animal_data = AnimalDatabase.get_animal(id)
	$AnimatedSprite2D.frames = load(animal_data["sprite_frames"])
	$AnimatedSprite2D.play("idle")
	print("Loaded animal: %s" % animal_data["animal_name"])

func _process(delta):
	# Ensure the position queue is valid and has enough data
	if position_queue.size() > delay_steps:
		# Update the follower's position to the delayed position in the queue
		global_position = position_queue[position_queue.size() - delay_steps]

	# Check if the player is moving (based on input)
	if (Input.is_action_pressed("ui_up") or 
		Input.is_action_pressed("ui_down") or 
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right")):
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = global_position.x > position_queue[position_queue.size() - 2].x
	else:
		$AnimatedSprite2D.play("idle")
