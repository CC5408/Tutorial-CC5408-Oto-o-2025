extends CharacterBody2D


@export var max_speed = 400
@export var acceleration = 500

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
	
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	# animations
	if move_input.is_zero_approx():
		playback.travel("idle")
	else:
		playback.travel("walk")
		animation_tree["parameters/idle/blend_position"] = move_input
		animation_tree["parameters/walk/blend_position"] = move_input
