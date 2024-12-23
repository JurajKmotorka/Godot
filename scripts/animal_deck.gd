extends Node

var animal_deck: Array = [1,2,3]  # Stores all animals in the deck
var selected_animals: Array = []  # Stores the animals chosen to fight (up to 4)
var max_followers: int = 4  # Maximum number of animals that can follow the player

# Adds an animal to the deck after a battle
func add_to_deck(animal_id: int) -> void:
	if animal_id not in animal_deck:
		animal_deck.append(animal_id)  # Add the animal to the deck if it's not already there
	
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
	for animal_id in animal_deck:
		if selected_animals.size() >= max_followers:
			break
		if animal_id not in selected_animals:
			selected_animals.append(animal_id)
