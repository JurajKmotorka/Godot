extends Area2D

# Export variables for easy configuration in the editor
@export var animal_name: String = "Default Animal"
@export var max_health: int = 50
@export var attack_power: int = 8

# Signal emitted when the player interacts with this animal
signal animal_interacted(animal_stats: Dictionary)

# Derived stats dictionary for consistency
func get_animal_stats() -> Dictionary:
	return {
		"name": animal_name,
		"max_health": max_health,
		"attack_power": attack_power
	}

# Called when the scene is ready
func _ready() -> void:
	print("%s is ready! Stats: %s" % [animal_name, get_animal_stats()])

# Function to handle interaction
func _on_body_entered(body: Node) -> void:
	if body.name == "Player":  # Adjust to your player node's name
		print("%s interacted!" % animal_name)
		emit_signal("animal_interacted", animal_name, get_animal_stats())
		queue_free()  # Optionally remove the animal from the map
