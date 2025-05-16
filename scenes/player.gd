class_name Player
extends CharacterBody2D

@export var max_speed = 400
@export var acceleration = 500
@export var gravity = 1000
@export var jump_speed = 600
@export var bullet_scene: PackedScene
@export var attack_sound: AudioStream
@export var attacking = false
@export var teleport_particles_scene: PackedScene


var dead = false


@onready var hitbox: Hitbox = $Pivot/Hitbox
@onready var jump_player: AudioStreamPlayer = $JumpPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree["parameters/AnimationNodeStateMachine/playback"] 
@onready var pivot: Node2D = $Pivot
@onready var bullet_spawn: Marker2D = $Pivot/BulletSpawn
@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $CanvasLayer/Label
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_component: HealthComponent = $HealthComponent



func _ready() -> void:
	animation_tree.active = true
	hitbox.damage_dealt.connect(_on_damage_dealt)
	health_component.health_changed.connect(_on_health_changed)
	health_bar.value = health_component.health
	health_bar.max_value = health_component.max_health
	health_component.died.connect(death)
	if Game.last_health > 0:
		health_component.health = Game.last_health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if dead:
		move_and_slide()
		return
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		jump_player.play()
	
	if is_on_floor():
		global_rotation = 0
	
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, max_speed * move_input, acceleration * delta)
	move_and_slide()
	
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#Debug.log(collision.get_collider().name)
	
	if Input.is_action_just_pressed("dash"):
		var direction = global_position.direction_to(get_global_mouse_position())
		global_rotation = direction.angle()
		velocity += direction * max_speed * 3
		pivot.scale.x = 1
	
	if Input.is_action_just_pressed("teleport"):
		var last_position = global_position
		global_position = get_global_mouse_position()
		if not teleport_particles_scene:
			return
		var teleport_particles_inst = teleport_particles_scene.instantiate()
		var direction = last_position.direction_to(global_position)
		get_parent().add_child(teleport_particles_inst)
		teleport_particles_inst.start(last_position, global_position)
		
	
	if Input.is_action_just_pressed("attack"):
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		# Game.play_sound(attack_sound)
		if is_on_floor():
			var dir = sign(get_global_mouse_position().x - global_position.x)
			if dir:
				pivot.scale.x = dir
		else:
			var direction = global_position.direction_to(get_global_mouse_position())
			global_rotation = direction.angle()
	
	
	

		
	
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
	dead = true
	playback.travel("death")
	await animation_tree.animation_finished
	#collision_shape_2d.set_deferred("disabled", true)
	collision_shape_2d.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
	get_tree().reload_current_scene()


func _on_health_changed(value: float) -> void:
		health_bar.value = value
		Game.last_health = value


func get_data() -> Dictionary:
	return {
		"pos_x": global_position.x,
		"pos_y": global_position.y,
		"health": health_component.health
	}


func load_data(dict: Dictionary) -> void:
	global_position.x = dict.pos_x
	global_position.y = dict.pos_y
	health_component.health = dict.health


func pick(item: String) -> void:
	Debug.log("%s picked %s" % [name, item])
	if item == "Potion":
		health_component.health += 20
