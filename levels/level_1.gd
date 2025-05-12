extends Node2D


@onready var pause_menu: PauseMenu = %PauseMenu
@onready var player: Player = $Player
@onready var pig: CharacterBody2D = $Pig


func _ready() -> void:
	pause_menu.load_pressed.connect(_on_load_pressed)


func _on_load_pressed() -> void:
	var file = FileAccess.open_encrypted_with_pass("user://data.save", FileAccess.READ, "123")
	var dict = JSON.parse_string(file.get_as_text())
	
	#LevelManager.go_to_level(dict.level)
	for key in dict:
		if key == "level":
			continue
		if key == "Player":
			player.load_data(dict[key])
		if key == "Pig":
			pig.load_data(dict[key])
