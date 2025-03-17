extends Hitbox

@export var max_speed = 400
@onready var timer: Timer = $Timer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	#timer.timeout.connect(queue_free)
	#timer.timeout.connect(func(): queue_free())
	#await timer.timeout
	await get_tree().create_timer(1).timeout
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	var velocity = transform.x * max_speed
	position +=  velocity * delta


func _on_body_entered(body: Node) -> void:
	if body is Player:
		return
	queue_free()
