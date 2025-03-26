extends MarginContainer

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(func(): get_tree().quit())
	credits.pressed.connect(func(): get_tree().change_scene_to_file("res://ui/credits.tscn"))

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
