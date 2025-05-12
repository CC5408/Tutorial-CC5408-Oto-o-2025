extends MarginContainer

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit
@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(func(): get_tree().quit())
	credits.pressed.connect(func(): get_tree().change_scene_to_file("res://ui/credits.tscn"))
	continue_button.pressed.connect(_on_continue_pressed)


func _on_start_pressed() -> void:
	LevelManager.start_game()


func _on_continue_pressed() -> void:
	# Load Game
	var file = FileAccess.open_encrypted_with_pass("user://data.save", FileAccess.READ, "123")
	var data = file.get_as_text()
	var dict = JSON.parse_string(data)
	var level = dict.level
	
	LevelManager.go_to_level(level)
