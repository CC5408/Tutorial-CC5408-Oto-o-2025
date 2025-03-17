extends MarginContainer

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


func _ready() -> void:
	start.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	quit.pressed.connect(func(): get_tree().quit())
	
