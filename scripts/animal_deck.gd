extends Node

const SAVE_FILE_PATH = "user://save_game.json"

var animal_deck: Dictionary = { 1: {"id": 1, "level": 1, "xp": 0}, }  # Use integer keys for consistency
var selected_animals: Dictionary = {}  # Holds selected animals for battle
var max_followers: int = 4  # Maximum number of animals that can follow the player
var base_xp_to_level: int = 10  # Base XP needed to level up
var next_uid: int = 3  # Start UID from 3 

# Save the current game state
func save_game() -> void:
	var data = {
		"animal_deck": animal_deck,
		"selected_animals": selected_animals,
		"next_uid": next_uid
	}
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.ModeFlags.WRITE)
	if file:
		var json_data = JSON.stringify(data)  # Corrected call
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
				var saved_data = json.data
				
				# Convert keys back to integers
				animal_deck.clear()
				for key in saved_data.get("animal_deck", {}).keys():
					animal_deck[int(key)] = saved_data["animal_deck"][key]
				
				selected_animals.clear()
				for key in saved_data.get("selected_animals", {}).keys():
					selected_animals[int(key)] = saved_data["selected_animals"][key]
				
				next_uid = int(saved_data.get("next_uid", 3))  # Default to 3 if not saved
				print("Game progress loaded.")
			else:
				print("Failed to parse saved data. Error code: %d" % result)
		else:
			print("Failed to load game progress.")
	else:
		print("Save file not found.")


# Adds an animal to the deck after a battle
func add_to_deck(animal_id: int, animal_lvl: int) -> void:
	# Ensure the UID is assigned properly
	var uid = next_uid  # Use the current next_uid
	next_uid += 1  # Increment only when a new animal is added

	# Check if the UID already exists (hardcoded or stored in data) and adjust if necessary
	while animal_deck.has(uid):  # Prevent duplication by checking existing UIDs
		print("Warning: UID %d already exists!" % uid)
		uid = next_uid  # Adjust to avoid duplication
		next_uid += 1

	animal_deck[uid] = {"id": animal_id, "level": animal_lvl, "xp": 0}

	# Automatically add to selected followers if there's room
	if selected_animals.size() < max_followers:
		selected_animals[uid] = animal_deck[uid]
	
	save_game()

# Award XP to an animal after a battle
func gain_xp(uid: int, xp_gained: int) -> void:
	if animal_deck.has(uid):
		animal_deck[uid]["xp"] += xp_gained
		while animal_deck[uid]["xp"] >= xp_to_next_level(animal_deck[uid]["level"]):
			animal_deck[uid]["xp"] -= xp_to_next_level(animal_deck[uid]["level"])
			animal_deck[uid]["level"] += 1
			print("Animal %d leveled up to level %d!" % [uid, animal_deck[uid]["level"]])
	
	if selected_animals.has(uid):
		selected_animals[uid] = animal_deck[uid]
	
	save_game()

# Selects animals for the battle (limit: 4)
func select_for_battle(uids: Array) -> void:
	if uids.size() > max_followers:
		print("You can only select up to %d animals!" % max_followers)
		return
	
	selected_animals.clear()
	for uid in uids:
		if animal_deck.has(uid):
			selected_animals[uid] = animal_deck[uid]
	
	save_game()

# Retrieves the selected animals for battle
func get_selected_animals() -> Dictionary:
	if selected_animals.size() == 0:
		choose_default_followers()
	return selected_animals

# Automatically chooses the first animals from the deck to fill up to max_followers
func choose_default_followers() -> void:
	selected_animals.clear()
	for uid in animal_deck.keys():
		if selected_animals.size() >= max_followers:
			break
		selected_animals[uid] = animal_deck[uid]

# Calculate the XP needed for the next level
func xp_to_next_level(level: int) -> int:
	return int(base_xp_to_level * (1.2 ** (level - 1)))

# Calculate enemy level based on the lowest level in the player's selected party
func get_enemy_level() -> int:
	var levels = []
	for uid in selected_animals.keys():
		levels.append(selected_animals[uid]["level"])
	return levels.min() if levels.size() > 0 else 1
