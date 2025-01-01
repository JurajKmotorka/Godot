extends Node2D

@export var spawn_positions: Array = []  # Predefined spawn positions
@onready var animal_pool = $SpawnPoints  # Group or parent node containing hidden animal scenes

func _ready():
	AnimalDeck.load_game()
	print("Game loaded")
	
	
