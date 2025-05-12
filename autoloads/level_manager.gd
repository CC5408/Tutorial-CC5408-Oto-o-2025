extends Node

@export var main_menu: PackedScene
@export var levels: Array[PackedScene]
@export var credits: PackedScene

var current_level = 0


func start_game() -> void:
	current_level = -1
	next_level()


func go_to_level(value: int) -> void:
	if value < levels.size():
		var level = levels[value]
		if level:
			current_level = level
			get_tree().change_scene_to_packed(level)
		else:
			Debug.log("Missing level")


func next_level() -> void:
	var next = current_level + 1
	if next < levels.size():
		current_level = next
		var level = levels[current_level]
		if level:
			get_tree().change_scene_to_packed(level)
		else:
			Debug.log("Missing level")
			next_level()
	else:
		go_to_credits()


func go_to_main_menu() -> void:
	if main_menu:
		get_tree().change_scene_to_packed(main_menu)


func go_to_credits() -> void:
	if credits:
		get_tree().change_scene_to_packed(credits)
