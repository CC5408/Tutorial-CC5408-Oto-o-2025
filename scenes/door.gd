extends Area2D


@onready var particles_area: Area2D = $ParticlesArea
@onready var particles: GPUParticles2D = $Particles

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	particles_area.body_entered.connect(func(body): particles.emitting = true)
	particles_area.body_exited.connect(func(body): particles.emitting = false)


func _on_body_entered(body: Node) -> void:
	var player = body as Player
	if player:
		LevelManager.next_level()
