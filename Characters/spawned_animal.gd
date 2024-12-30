extends CharacterBody2D

@export var idle_range: float = 10.0 # Max distance for idle movement
@export var idle_speed: float = 1.0 # Speed of idle movement
@export var aquatic: bool = false # Toggle for aquatic spawn point

var animal_data: Dictionary # Stores the data for this animal
var original_position: Vector2 # The spawn position
var player_in_area: bool = false
var animal_id = 0

# Load animal data
func load_animal_data(key: int):
	animal_data = AnimalDatabase.get_animal(key)
	print("Loaded sprite frames:", animal_data["sprite_frames"])
	$AnimatedSprite2D.sprite_frames = load(animal_data["sprite_frames"])
	animal_id = key
	original_position = global_position
	self.visible = true  # Make the animal visible
	print("Animal data loaded successfully.")

# Return whether the spawn point is aquatic
func is_aquatic() -> bool:
	return aquatic

# Called when the node enters the scene tree
func _ready():
	idle_movement()
	
	# Connect signals for Area2D
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

# Process player input for starting a fight
func _process(delta: float) -> void:
	if player_in_area and Input.is_action_pressed("ui_accept"): 
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
		$AnimatedSprite2D.flip_h = direction.x < 0
		velocity = direction * idle_speed
		move_and_slide()
		await get_tree().process_frame # Wait for the next frame

# Handle collision with the player
func _on_body_entered(body):
	if body.name == "Player":
		print("Collision detected with Player!")
		player_in_area = true
	else:
		print("Collision detected with: %s" % body.name)

# Handle when the player exits collision
func _on_body_exited(body):
	if body.name == "Player":
		print("Collision with Player terminated!")
		player_in_area = false
	else:
		print("Collision ended with: %s" % body.name)

# Start the fight scene
func start_fight() -> void:
	var fight_scene = load("res://BattleScene.tscn").instantiate()
	var current_scene = get_tree().current_scene

	# Replace the current scene with the new one
	if current_scene:
		current_scene.queue_free()
	get_tree().root.add_child(fight_scene)
	get_tree().current_scene = fight_scene

	# Pass animal data to the fight scene
	fight_scene.set_enemy_data(animal_id)
