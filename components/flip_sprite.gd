class_name FlipSprite
extends Sprite2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	var direction = owner.transform.x.dot(Vector2.RIGHT)
	if direction:
		flip_v = direction < 0
