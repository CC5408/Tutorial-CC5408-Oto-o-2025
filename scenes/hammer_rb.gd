extends RigidBody2D

@onready var trail_spawn: Node2D = $TrailSpawn
@onready var line_2d: Line2D = $Line2D


func _process(delta: float) -> void:
	_update_trail()


func _update_trail() -> void:
	if line_2d.points.size() 	> 20:
		line_2d.remove_point(0)
	line_2d.add_point(line_2d.to_local(trail_spawn.global_position))
