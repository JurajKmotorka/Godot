extends CharacterBody2D

# Declare the signal
signal animal_interacted

@export var follow_speed = 100  # Speed at which the mob follows the player
@export var stop_distance = 20  # Distance at which the mob stops behind the player
var player_collision: CollisionShape2D = null  # Reference to the player's CollisionShape2D
var following_player = false  # Whether the mob is following the player

# Called when the node enters the scene tree
func _ready() -> void:
	# Connect the area_entered signal from the animal's InteractionArea
	$InteractionArea.connect("area_entered", Callable(self, "_on_area_entered"))
	$AnimatedSprite2D.play()
	print("Animal is ready!")

# Handle area_entered signal
func _on_area_entered(area: Area2D) -> void:
	if area.name == "InteractionArea":  # Detect player's InteractionArea
		var player_node = area.get_parent()  # Get the parent node (Player)
		if player_node:  # Ensure the player node is valid
			player_collision = player_node.get_node("CollisionShape2D")  # Get the player's CollisionShape2D
			following_player = true
			print("Animal is now following the player's feet!")
			emit_signal("animal_interacted")  # Emit the signal when interaction occurs

# Called every physics frame to update mob movement
func _physics_process(delta: float) -> void:
	if velocity.length() < 2:
		$AnimatedSprite2D.animation = "idle"

	if following_player and player_collision:
		# Calculate direction to the player's CollisionShape2D (at the player's feet)
		var direction = (player_collision.global_position - global_position).normalized()

		# Calculate distance to the CollisionShape2D
		var distance_to_target = global_position.distance_to(player_collision.global_position)

		if distance_to_target > stop_distance:
			# Move towards the player's feet
			velocity = direction * follow_speed
			move_and_slide()
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = direction.x < 0  # Flip sprite based on movement direction
		else:
			# Stop when close enough to the player's feet
			velocity = Vector2.ZERO
			move_and_slide()
