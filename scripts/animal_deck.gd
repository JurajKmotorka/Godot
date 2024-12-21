extends Node

var animal_deck: Array = [ 1, 2, 3, 9]  # Stores all animals in the deck
var selected_animals: Array = []  # Stores the animals chosen to fight (up to 4)
var max_followers: int = 4  # Maximum number of animals that can follow the player

# Adds an animal to the deck after a battle
func add_to_deck(animal_id: int) -> void:
	animal_deck.append(animal_id)
	# Automatically select up to 4 animals to follow if none are manually selected
	choose_default_followers()

# Selects animals for the battle (limit: 4)
func select_for_battle(animal_ids: Array) -> void:
	if animal_ids.size() > max_followers:
		print("You can only select up to 4 animals!")
		return
	selected_animals = animal_ids
	# Ensure that if the player manually selects less than 4 animals, the default followers are updated
	if selected_animals.size() < max_followers:
		choose_default_followers()

# Retrieves the selected animals for battle
func get_selected_animals() -> Array:
	# If no animals are selected manually, return the first 4 from the deck
	if selected_animals.size() == 0:
		choose_default_followers()  # Automatically select up to 4 animals
	return selected_animals

# Automatically chooses the first 4 animals from the deck if none are selected
func choose_default_followers() -> void:
	# Clear the selected animals if automatic selection is needed
	if selected_animals.size() == 0:
		# If there are fewer than 4 animals, add all available animals to the selected list
		selected_animals = animal_deck.slice(0, min(animal_deck.size(), max_followers))
