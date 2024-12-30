extends Node2D

@onready var animal_nodes = get_children()  # All child animal nodes

func _ready():
	# Example: Spawn random animals
	for node in animal_nodes:
		spawn_random_animal(node)

func spawn_random_animal(animal_node):
	# Check if the spawn point is aquatic
	var is_aquatic = animal_node.has_method("is_aquatic") and animal_node.is_aquatic()
	
	# Get animal IDs from the database
	var animal_ids = AnimalDatabase.animals.keys()
	if animal_ids.size() == 0:
		print("No animals available to spawn.")
		return

	# Build a weighted list of animal IDs based on rarity and type
	var weighted_animal_ids = []
	for animal_id in animal_ids:
		var rarity = AnimalDatabase.animals[animal_id]["rarity"]  # Assume rarity is in the animal data
		var is_fish = AnimalDatabase.animals[animal_id].has("class") and AnimalDatabase.animals[animal_id]["class"] == "Fish"
		
		# Filter animals based on the spawn point type
		if is_aquatic and not is_fish:
			continue  # Skip non-fish for aquatic spawn points
		if not is_aquatic and is_fish:
			continue  # Skip fish for non-aquatic spawn points
		
		# Add animal IDs to the weighted list based on rarity
		var weight = rarity_to_weight(rarity)
		for i in range(weight):
			weighted_animal_ids.append(animal_id)
	
	if weighted_animal_ids.size() == 0:
		print("No animals matched the criteria for this spawn point.")
		return

	# Pick a random animal from the weighted list
	var random_id = weighted_animal_ids[randi() % weighted_animal_ids.size()]

	# Send the data to the child node and activate it
	if animal_node.has_method("load_animal_data"):
		animal_node.load_animal_data(random_id)
		animal_node.visible = true
		if is_aquatic:
			print("Spawned aquatic animal '%s'." % random_id)
		else:
			print("Spawned non-aquatic animal '%s'." % random_id)
	else:
		print("Child node does not support loading animal data.")

# Convert rarity to weight for weighted selection
func rarity_to_weight(rarity: String) -> int:
	# Define weights based on rarity levels
	match rarity:
		"common":
			return 10  # Most frequent
		"uncommon":
			return 5
		"rare":
			return 2
		"epic":
			return 1
		"legendary":
			return 1  # Adjust if needed
		_:
			return 0  # Invalid rarity (won't spawn)
