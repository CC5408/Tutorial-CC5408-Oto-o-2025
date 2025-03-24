extends PanelContainer

@onready var resume: Button = %Resume
@onready var retry: Button = %Retry
@onready var main_menu: Button = %MainMenu
@onready var quit: Button = %Quit


func _ready() -> void:
	quit.pressed.connect(func(): get_tree().quit())
	retry.pressed.connect(_on_retry_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	resume.pressed.connect(_on_resume_pressed)
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


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
