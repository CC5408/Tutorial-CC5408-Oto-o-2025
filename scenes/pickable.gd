extends Area2D

@export var item = "Godot"


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	var player = body as Player
	if player:
		player.pick(item)
		queue_free()
