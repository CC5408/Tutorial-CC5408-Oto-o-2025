extends CharacterBody2D

@export var max_speed = 400
@export var acceleration = 500
@export var gravity = 1000
@export var jump_speed = 600
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"] 
@onready var pivot: Node2D = $Pivot


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
