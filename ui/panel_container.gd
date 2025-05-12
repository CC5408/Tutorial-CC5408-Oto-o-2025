class_name PauseMenu
extends PanelContainer

signal load_pressed

@onready var resume: Button = %Resume
@onready var retry: Button = %Retry
@onready var main_menu: Button = %MainMenu
@onready var quit: Button = %Quit
@onready var save: Button = %Save
@onready var load_button: Button = %LoadButton


func _ready() -> void:
	quit.pressed.connect(func(): get_tree().quit())
	retry.pressed.connect(_on_retry_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	resume.pressed.connect(_on_resume_pressed)
	save.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_save_pressed() -> void:
	# Save Game
	var dict = {
		"level": LevelManager.current_level
	}
	
	for node in get_tree().get_nodes_in_group("Savable"):
		dict[node.name] = node.get_data()
	
	
	var file = FileAccess.open_encrypted_with_pass("user://data.save", FileAccess.WRITE, "123")
	var data = JSON.stringify(dict)
	file.store_string(data)
	
	handle_config()


func handle_config() -> void:
	var config = ConfigFile.new()
	config.set_value("Video", "fullscreen", false)
	config.set_value("Video", "resolution", "1280x720")
	config.set_value("Audio", "music_volume", 0.5)
	config.set_value("Audio", "sfx_volume", 0)
	config.set_value("Audio", "voice_volume", 1)
	config.save("user://user.cfg")


func _on_load_pressed() -> void:
	load_pressed.emit()
	_on_resume_pressed()
