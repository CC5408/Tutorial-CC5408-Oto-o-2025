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
