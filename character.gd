extends CharacterBody2D

@export var move_speed : float = 2
var input_direction = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Reset input_direction to zero each frame
	input_direction = Vector2.ZERO

	# Handle horizontal input when vertical input is zero
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	# Handle vertical input when horizontal input is zero
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	# Calculate velocity and apply movement
	velocity = input_direction * move_speed
	move_and_slide()

	# Move
	position += velocity
	move_and_slide()
	# Update the animated sprite based on movement
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.stop()
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0  # Flip sprite horizontally based on direction
		
	
	
