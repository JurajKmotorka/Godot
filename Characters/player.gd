extends CharacterBody2D

@export var move_speed : float = 100

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	# Normalize input_direction to ensure consistent movement speed
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()

	# Calculate velocity based on input direction and move_speed
	velocity = input_direction.normalized() * move_speed
	
	# Move
	position += velocity
	move_and_slide()
	# Update the animated sprite based on movement
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0  # Flip sprite horizontally based on direction
	else:
		$AnimatedSprite2D.stop()
	
