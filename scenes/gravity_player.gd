extends CharacterBody2D


@export var max_speed = 400
@export var acceleration = 500
@export var rotation_acceleration = 10
@export var gravity = 1000
@export var jump_speed = 600

@onready var pivot: Node2D = $Pivot


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity = -global_transform.y * jump_speed
		

	
	var move_input = Input.get_axis("move_left", "move_right")
	var move_direction = global_transform.x
	velocity = velocity.move_toward(max_speed * move_input * move_direction, acceleration * delta)
	move_and_slide()
	
	var gravity_direction = get_gravity().normalized()
	var target_angle = gravity_direction.rotated(-PI/2).angle()
	global_rotation = rotate_toward(global_rotation, target_angle, rotation_acceleration * delta)
	
	up_direction = -global_transform.y
	
	if move_input != 0:
		pivot.scale.x = sign(move_input)
