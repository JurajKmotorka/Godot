extends Node

const SAVE_FILE_PATH = "user://save_game.json"

# Save the game data to a file
func save_game(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.ModeFlags.WRITE)
	if file:
		var json_data = JSON.new().stringify(data)  # Serialize the dictionary into a JSON string
		file.store_string(json_data)
		file.close()
		print("Game progress saved successfully.")
	else:
		print("Failed to save game progress.")

# Load the game data from a file
func load_game() -> Dictionary:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.ModeFlags.READ)
		if file:
			var json_data = file.get_as_text()
			file.close()
			
			var json = JSON.new()  # Create an instance of JSON
			var result = json.parse(json_data)  # Parse the JSON string back into a Dictionary
			if result == OK:
				return json.result  # Return the parsed dictionary
			else:
				print("Failed to parse save data.")
		else:
			print("Failed to load game progress.")
	else:
		print("Save file not found. Starting fresh.")
	return {}  # Return an empty dictionary if no save file exists
