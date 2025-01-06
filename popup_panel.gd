extends PopupPanel

@onready var deck_list: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var save_button: Button = $HBoxContainer/VBoxContainer2/SaveChangesButton
@onready var close_button: Button = $HBoxContainer/VBoxContainer2/CloseButton

func _ready() -> void:
	save_button.pressed.connect(_on_save_changes_pressed)
	close_button.pressed.connect(_on_close_deck_pressed)

# Open the deck popup
func _on_open_deck_button_pressed() -> void:
	populate_deck()
	popup_centered()  # Opens the popup and centers it on the screen

# Populate the deck with animal data
func populate_deck() -> void:
	for child in deck_list.get_children():  # Clear previous entries
		child.queue_free()

	for uid in AnimalDeck.animal_deck.keys():  # Iterate over UIDs instead of directly accessing `animal_deck`
		var animal = AnimalDeck.animal_deck[uid]
		var deck_item = create_deck_item(animal)
		deck_list.add_child(deck_item)

# Create a UI element for a single animal in the deck
func create_deck_item(animal: Dictionary) -> Control:
	var container = HBoxContainer.new()

	var name_label = Label.new()
	name_label.text = "ID: %d | Level: %d | XP: %d" % [animal["id"], animal["level"], animal["xp"]]
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var select_button = Button.new()
	select_button.text = "Deselect" if AnimalDeck.selected_animals.has(str(animal["id"])) else "Select"
	select_button.pressed.connect(func() -> void: _on_select_button_pressed(animal, select_button))

	container.add_child(name_label)
	container.add_child(select_button)
	return container

# Handle selecting or deselecting an animal
func _on_select_button_pressed(animal: Dictionary, button: Button) -> void:
	var uid = animal["id"]  # Ensure we're using the integer ID here
	if AnimalDeck.selected_animals.has(str(uid)):  # Store it as a string in `selected_animals` but use integer for processing
		AnimalDeck.selected_animals.erase(str(uid))
		button.text = "Select"
	elif AnimalDeck.selected_animals.size() < AnimalDeck.max_followers:
		AnimalDeck.selected_animals[str(uid)] = animal  # Store as a string in `selected_animals`
		button.text = "Deselect"
	else:
		print("Max followers reached!")

# Save changes and close the popup
func _on_save_changes_pressed() -> void:
	AnimalDeck.save_game()  # Save the updated deck if needed
	print("Changes saved!")
	hide()

# Close the popup without saving
func _on_close_deck_pressed() -> void:
	hide()
