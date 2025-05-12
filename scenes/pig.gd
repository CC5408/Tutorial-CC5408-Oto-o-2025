extends CharacterBody2D


@export var max_speed = 400
@export var acceleration = 500
@export var gravity = 1000

@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D
@onready var pivot: Node2D = $Pivot


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = move_toward(velocity.x, max_speed * pivot.scale.x, acceleration * delta)
	move_and_slide()
	
	if ray_cast_2d.is_colliding():
		pivot.scale.x *= -1


func take_damage(damage: float) -> void:
	queue_free()


func get_data() -> Dictionary:
	return {
		"pos_x": global_position.x,
		"pos_y": global_position.y,
	}


func load_data(dict: Dictionary) -> void:
	global_position.x = dict.pos_x
	global_position.y = dict.pos_y
