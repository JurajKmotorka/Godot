extends Node2D

var animal_data: Dictionary  # To store the data passed from the AnimalChain

# This function loads the data into the animal's properties
func load_animal_id(id: int) -> void:
	var data = AnimalDatabase.get_animal(id)
	$AnimatedSprite2D.frames = load(data["sprite_frames"])  # Load the sprite frames
	$AnimatedSprite2D.play("idle")  # Play the idle animation
	# Set up other animal stats and behaviors here
	print("Loaded animal data for %s" % data["animal_name"])
