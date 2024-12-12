extends CharacterBody2D

var animal_data: Dictionary # Stores the data for this animal
@export var idle_range: float = 10.0 # Max distance for idle movement
@export var idle_speed: float = 1.0 # Speed of idle movement

var original_position: Vector2 # The spawn position

func load_animal_data(animal_name: int, data: Dictionary):
	print("loaded spriteframes:")
	print(data["sprite_frames"])
	$AnimatedSprite2D.sprite_frames = load(data["sprite_frames"])
	

	original_position = global_position
	self.visible = true # Make the animal visible
	print("data received")

func _ready():
	idle_movement()

# Idle movement with await
func idle_movement() -> void:
	await get_tree().create_timer(1.0).timeout
	while true:
		# Random offset within idle range
		var target_position = original_position + Vector2(randf_range(-idle_range, idle_range), randf_range(-idle_range, idle_range))
		await move_to(target_position)
		await get_tree().create_timer(randf_range(1.0, 3.0)).timeout

# Smooth movement towards a target
func move_to(target: Vector2) -> void:
	while global_position.distance_to(target) > 1.0:
		var direction = (target - global_position).normalized()
		velocity = direction * idle_speed
		move_and_slide()
		await get_tree().process_frame # Wait for the next frame

# Handle collision with the player
func _on_Player_body_entered(body: Node) -> void:
	if body.name == "Player":
		start_fight()

# Start the fight scene
func start_fight() -> void:
	# Load the fight scene
	var fight_scene = load("res://scenes/FightScene.tscn").instantiate()
	
	# Transition to the fight scene
	get_tree().change_scene_to_instance(fight_scene)
	
	# Pass animal data to the fight scene
	if fight_scene.has_method("set_enemy_data"):
		fight_scene.set_enemy_data(animal_data)
