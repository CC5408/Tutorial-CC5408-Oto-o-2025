class_name Player
extends CharacterBody2D

@export var max_speed = 400
@export var acceleration = 500
@export var gravity = 1000
@export var jump_speed = 600
@export var bullet_scene: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"] 
@onready var pivot: Node2D = $Pivot
@onready var bullet_spawn: Marker2D = $Pivot/BulletSpawn



func _ready() -> void:
	animation_tree.active = true



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
	
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, max_speed * move_input, acceleration * delta)
	move_and_slide()
	
	if not move_input and is_on_floor() and Input.is_action_just_pressed("attack"):
		playback.travel("attack")
		var dir = sign(get_global_mouse_position().x - global_position.x)
		if dir:
			pivot.scale.x = dir
			
		return
	
	# animation
	if move_input != 0:
		pivot.scale.x = sign(move_input)
	
	if is_on_floor():
		if abs(velocity.x) > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")


func fire() -> void:
	var bullet_inst = bullet_scene.instantiate()
	get_parent().add_child(bullet_inst)
	bullet_inst.global_rotation = bullet_spawn.global_position.direction_to(get_global_mouse_position()).angle() 
	bullet_inst.global_position = bullet_spawn.global_position
