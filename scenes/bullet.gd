extends Hitbox

@export var max_speed = 400
@export var alpha_curve: Curve

@onready var timer: Timer = $Timer

func _ready() -> void:
	damage_dealt.connect(func(): queue_free())
	body_entered.connect(_on_body_entered)
	#timer.timeout.connect(queue_free)
	#timer.timeout.connect(func(): queue_free())
	await timer.timeout
	#await get_tree().create_timer(1).timeout
	queue_free()


func _process(delta: float) -> void:
	var alpha = alpha_curve.sample(1 - (timer.time_left / timer.wait_time))
	modulate.a = alpha 
	
	
func _physics_process(delta: float) -> void:
	var velocity = transform.x * max_speed
	position +=  velocity * delta


func _on_body_entered(body: Node) -> void:
	if body is Player:
		return
	queue_free()
