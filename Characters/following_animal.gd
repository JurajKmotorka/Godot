extends CharacterBody2D

var animal_data: Dictionary  # To store the data passed from the AnimalChain
var previous_position: Vector2 = Vector2.ZERO  # Store the previous position to check if it's moving

# This function loads the data into the animal's properties
func load_animal_id(id: int) -> void:
	var data = AnimalDatabase.get_animal(id)
	$AnimatedSprite2D.frames = load(data["sprite_frames"])  # Load the sprite frames
	$AnimatedSprite2D.play("idle")  # Play the idle animation initially
	# Set up other animal stats and behaviors here
	print("Loaded animal data for %s" % data["animal_name"])

func _ready() -> void:
	# Initialize the previous position at the start
	previous_position = global_position

func _process(delta: float) -> void:
	# Check if the position has changed since the last frame
	if global_position != previous_position :
		update_animation(true)  # Animal is moving
		
			
	else:
		update_animation(false)  # Animal is idle

	# Update previous position for next frame
	previous_position = global_position

# Function to update the animation based on whether the animal is moving or idle
func update_animation(is_moving: bool) -> void:
	if is_moving:
		$AnimatedSprite2D.play("walk")  # Play walking animation
		if previous_position.x - global_position.x > 1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")  # Play idle animation
