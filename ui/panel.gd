extends Panel


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		Debug.log("click")
