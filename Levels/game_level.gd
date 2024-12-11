extends Node

# Called when the scene is ready
func _ready() -> void:
	# Get reference to the animal node (adjust path as necessary)
	var animal = $Animal  # Adjust this to the correct path of your animal node
	
	if animal:
		# Connect the animal_interacted signal to the handler function using the correct format
		animal.animal_interacted.connect(self._on_animal_interacted)  # Connect signal here
	else:
		print("Animal node not found!")
		return

# Function to handle the animal's interaction and start the battle
func _on_animal_interacted() -> void:
	print("Animal interacted, starting battle...")
	start_battle()

# Start the battle with the player
func start_battle():
	# Load and instantiate the battle scene
	get_tree().change_scene_to_file("res://BattleScene.tscn")
