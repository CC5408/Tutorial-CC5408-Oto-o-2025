extends Node2D


@export var max_speed = 200
@export var acceleration = 500
@export var force_mult = 10
@export var torque = 5000000

@onready var flip_sprite: FlipSprite = $FlipSprite
@onready var rigid_body_2d: RigidBody2D = $RigidBody2D


func _physics_process(delta: float) -> void:
	var direction = get_global_mouse_position() - rigid_body_2d.global_position
	rigid_body_2d.apply_force(direction * force_mult)
	if Input.is_action_pressed("spin"):
		rigid_body_2d.apply_torque(torque * delta)
