extends CharacterBody2D

var animal_data: Dictionary # Stores the data for this animal
@export var idle_range: float = 10.0 # Max distance for idle movement
@export var idle_speed: float = 1.0 # Speed of idle movement

var original_position: Vector2 # The spawn position
var player_in_area: bool = false
var animal_id = 0
func load_animal_data(key: int):
	animal_data = AnimalDatabase.get_animal(key)
	print("loaded spriteframes:")
	print(animal_data["sprite_frames"])
	$AnimatedSprite2D.sprite_frames = load(animal_data["sprite_frames"])
	animal_id = key
	

	original_position = global_position
	self.visible = true # Make the animal visible
	print("data received")

func _ready():
	idle_movement()
	
	# Connect the `body_entered` signal from Area2D to this script
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	
func _process(delta: float) -> void:
	
	if player_in_area and Input.is_action_pressed("accept"): # 'I' is mapped to 'accept' by default
		GlobalData.player_position = $Area2D.global_position
		start_fight()

# Idle movement with await
func idle_movement() -> void:
	await get_tree().create_timer(1.0).timeout
	while true:
		# Random offset within idle range
		var target_position = original_position + Vector2(randf_range(-idle_range, idle_range), randf_range(-idle_range, idle_range))
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
		
		await move_to(target_position)
		$AnimatedSprite2D.animation = "idle"
		
		await get_tree().create_timer(randf_range(1.0, 3.0)).timeout

# Smooth movement towards a target
func move_to(target: Vector2) -> void:
	while global_position.distance_to(target) > 1.0:
		var direction = (target - global_position).normalized()
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		velocity = direction * idle_speed
		move_and_slide()
		await get_tree().process_frame # Wait for the next frame

func _on_body_entered(body):
	if body.name == "Player":
		print("Collision detected with Player!")
		player_in_area = true
		
	else:
		print("Collision detected with: %s" % body.name)
		
func _on_body_exited(body):
	if body.name == "Player":
		print("Collision with Player terminated!")
		player_in_area = false
		
	else:
		print("Collision detected with: %s" % body.name)


# Start the fight scene
func start_fight() -> void:
	# Load the fight scene
	var fight_scene = load("res://BattleScene.tscn").instantiate()
	var current_scene = get_tree().current_scene
# Replace the current scene with the new scene
	if current_scene:
		current_scene.queue_free()  # Remove the current scene from the tree
	get_tree().root.add_child(fight_scene)  # Add the new scene as a child of the root
	get_tree().current_scene = fight_scene  # Set the new scene as the current scene

	# Pass animal data to the fight scene
	fight_scene.set_enemy_data(animal_id)
