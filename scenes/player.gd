class_name Player
extends CharacterBody2D

@export var max_speed = 400
@export var acceleration = 500
@export var gravity = 1000
@export var jump_speed = 600
@export var bullet_scene: PackedScene
@export var attack_sound: AudioStream
@export var attacking = false


var dead = false


@onready var hitbox: Hitbox = $Pivot/Hitbox
@onready var jump_player: AudioStreamPlayer = $JumpPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"] 
@onready var pivot: Node2D = $Pivot
@onready var bullet_spawn: Marker2D = $Pivot/BulletSpawn
@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $CanvasLayer/Label



func _ready() -> void:
	animation_tree.active = true
	hitbox.damage_dealt.connect(_on_damage_dealt)
	label.text = str(Game.health)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if dead:
		move_and_slide()
		return
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		jump_player.play()
	
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, max_speed * move_input, acceleration * delta)
	move_and_slide()
	
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#Debug.log(collision.get_collider().name)
	
	if not attacking and not move_input and is_on_floor() and Input.is_action_just_pressed("attack"):
		attacking = true
		playback.travel("attack")
		# Game.play_sound(attack_sound)
		var dir = sign(get_global_mouse_position().x - global_position.x)
		if dir:
			pivot.scale.x = dir
	
	if attacking:
		return
	
	# animation
	if move_input != 0:
		pivot.scale.x = sign(move_input)
	
	if is_on_floor():
		if move_input or abs(velocity.x) > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")


func _on_damage_dealt() -> void:
	Debug.log("I made damage!")

func fire() -> void:
	if not bullet_scene:
		return
	var bullet_inst = bullet_scene.instantiate()
	get_parent().add_child(bullet_inst)
	bullet_inst.global_rotation = bullet_spawn.global_position.direction_to(get_global_mouse_position()).angle() 
	bullet_inst.global_position = bullet_spawn.global_position
	
	var tween = create_tween()
	tween.tween_property(sprite_2d, "scale:y", 5, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(sprite_2d, "modulate", Color.LIME, 0.1)
	tween.tween_property(sprite_2d, "scale:y", 4, 0.05)
	tween.parallel().tween_property(sprite_2d, "modulate", Color.WHITE, 0.05)


func take_damage(damage: float) -> void:
	death()
	var camera_position = camera_2d.global_position
	remove_child(camera_2d)
	get_parent().add_child(camera_2d)
	camera_2d.global_position = camera_position


func death() -> void:
	Game.health -= 1
	label.text = str(Game.health)
	dead = true
	playback.travel("death")
	await animation_tree.animation_finished
	#collision_shape_2d.set_deferred("disabled", true)
	collision_shape_2d.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
	#if Game.health <= 0:
		#return
	#get_tree().reload_current_scene()
