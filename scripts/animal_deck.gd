extends Node

# Stores all animals in the deck along with their levels and XP
var animal_deck: Array = [{"id": 1, "level": 1, "xp": 0},{"id": 12, "level": 1, "xp": 0}]  
var selected_animals: Array = []  # Stores the animals chosen to fight (up to 4)
var max_followers: int = 4  # Maximum number of animals that can follow the player
var base_xp_to_level: int = 10  # Base XP needed to level up

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

# Selects animals for the battle (limit: 4)
func select_for_battle(animal_ids: Array) -> void:
	if animal_ids.size() > max_followers:
		print("You can only select up to %d animals!" % max_followers)
		return
	selected_animals = animal_ids
	
	# Automatically fill up to the maximum with default followers if fewer than max are selected
	if selected_animals.size() < max_followers:
		choose_default_followers()

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
