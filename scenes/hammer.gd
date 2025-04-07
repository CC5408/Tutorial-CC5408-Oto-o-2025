extends Node2D


@export var max_speed = 200
@export var acceleration = 500
@export var force_mult = 10
@export var torque = 5000000


@onready var flip_sprite: FlipSprite = $RigidBody2D/FlipSprite
@onready var hammer_rb: RigidBody2D = $HammerRB
@onready var line_2d: Line2D = $Line2D


func _physics_process(delta: float) -> void:
	var direction = get_global_mouse_position() - hammer_rb.global_position
	hammer_rb.apply_force(direction * force_mult)
	if Input.is_action_pressed("spin"):
		hammer_rb.apply_torque(torque * delta)
