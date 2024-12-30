extends CharacterBody2D

@export var joystick: VirtualJoystick
@export var move_speed: float = 100
var input_direction = Vector2.ZERO

func _ready():
	if GlobalData.player_position != Vector2.ZERO:
		position = GlobalData.player_position

func _physics_process(_delta: float) -> void:
	var raw_output = Vector2.ZERO

	if joystick and joystick.is_pressed:
		# Get joystick's raw output
		raw_output = joystick.output
	else:
		# Get keyboard input using Input.get_vector
		raw_output = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Determine the dominant direction (cardinal only)
	if abs(raw_output.x) > abs(raw_output.y):
		input_direction = Vector2(1 if raw_output.x > 0 else -1, 0)
	elif raw_output != Vector2.ZERO:  # Only update for valid input
		input_direction = Vector2(0, 1 if raw_output.y > 0 else -1)
	else:
		input_direction = Vector2.ZERO

	# Apply movement
	velocity = input_direction * move_speed
	move_and_slide()

	# Update the animated sprite
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0  # Flip sprite horizontally based on direction
	else:
		$AnimatedSprite2D.stop()
