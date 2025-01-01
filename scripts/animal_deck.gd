extends Node

const SAVE_FILE_PATH = "user://save_game.json"

# Stores all animals in the deck along with their levels and XP
var animal_deck: Array = [{"id": 1, "level": 1, "xp": 0}]  
var selected_animals: Array = []  # Stores the animals chosen to fight (up to 4)
var max_followers: int = 4  # Maximum number of animals that can follow the player
var base_xp_to_level: int = 10  # Base XP needed to level up

# Save the current game state
func save_game() -> void:
	var data = {
		"animal_deck": animal_deck,
		"selected_animals": selected_animals
	}
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.ModeFlags.WRITE)
	if file:
		var json_data = JSON.new().stringify(data)
		file.store_string(json_data)
		file.close()
		print("Game progress saved.")
	else:
		print("Failed to save game progress.")

# Load the game state
func load_game() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.ModeFlags.READ)
		if file:
			var json_data = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var result = json.parse(json_data)
			if result == OK:
				var saved_data = json.data  # Use .data to access the parsed data
				animal_deck = saved_data.get("animal_deck", [])
				selected_animals = saved_data.get("selected_animals", [])
				print("Game progress loaded.")
			else:
				print("Failed to parse saved data. Error code: %d" % result)
		else:
			print("Failed to load game progress.")
	else:
		print("Save file not found.")

# Adds an animal to the deck after a battle
func add_to_deck(animal_id: int) -> void:
	# Check if the animal is already in the deck
	for animal in animal_deck:
		if animal["id"] == animal_id:
			return  # Animal is already in the deck, no action needed

	# Add the new animal with level 1 and 0 XP
	animal_deck.append({"id": animal_id, "level": 1, "xp": 0})
	
	# Automatically add the defeated animal to selected followers if there's room
	if selected_animals.size() < max_followers:
		selected_animals.append(animal_id)
	
	save_game()  # Save progress

# Selects animals for the battle (limit: 4)
func select_for_battle(animal_ids: Array) -> void:
	if animal_ids.size() > max_followers:
		print("You can only select up to %d animals!" % max_followers)
		return
	selected_animals = animal_ids
	
	# Automatically fill up to the maximum with default followers if fewer than max are selected
	if selected_animals.size() < max_followers:
		choose_default_followers()
	
	save_game()  # Save progress

# Retrieves the selected animals for battle
func get_selected_animals() -> Array:
	# If no animals are selected manually, return the first animals up to max_followers
	if selected_animals.size() == 0:
		choose_default_followers()
	return selected_animals

# Automatically chooses the first animals from the deck to fill up to max_followers
func choose_default_followers() -> void:
	# Fill selected_animals up to max_followers with animals from the deck
	for animal in animal_deck:
		if selected_animals.size() >= max_followers:
			break
		if animal["id"] not in selected_animals:
			selected_animals.append(animal["id"])

# Award XP to an animal after a battle
func gain_xp(animal_id: int, xp_gained: int) -> void:
	for animal in animal_deck:
		if animal["id"] == animal_id:
			animal["xp"] += xp_gained
			print(animal_deck)
			# Check for level up
			while animal["xp"] >= xp_to_next_level(animal["level"]):
				animal["xp"] -= xp_to_next_level(animal["level"])
				animal["level"] += 1
				print("Animal %d leveled up to level %d!" % [animal_id, animal["level"]])
			break
	
	save_game()  # Save progress

# Calculate the XP needed for the next level
func xp_to_next_level(level: int) -> int:
	return int(base_xp_to_level * (1.2 ** (level - 1)))  # Increases XP requirement exponentially

# Calculate enemy level based on the lowest level in the player's selected party
func get_enemy_level() -> int:
	var levels = []
	for animal_id in selected_animals:
		for animal in animal_deck:
			if animal["id"] == animal_id:
				levels.append(animal["level"])
	if levels.size() > 0:
		return levels.min()
	return 1  # Default to level 1 if no animals are selected
