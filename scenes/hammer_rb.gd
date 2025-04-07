extends RigidBody2D

@onready var trail_spawn: Node2D = $TrailSpawn
@onready var line_2d: Line2D = $TrailSpawn/Line2D


func _process(delta: float) -> void:
	_update_trail()


func _update_trail() -> void:
	line_2d.remove_point(line_2d.get_point_count())
	line_2d.add_point(line_2d.to_local(trail_spawn.global_position))
