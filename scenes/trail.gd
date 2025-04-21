extends Line2D

@onready var offset := transform

func _process(delta: float) -> void:
	var parent = get_parent() as Node2D
	if parent:
		global_transform = parent.global_transform * offset
	_update_trail()


func _update_trail() -> void:
	if points.size() > 20:
		remove_point(0)
	add_point(position)
