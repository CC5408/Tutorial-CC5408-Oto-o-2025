class_name Combo
extends Resource


enum Key {
	NONE,
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN
}


@export var name: String
@export var keys: Array[Combo.Key]


static func get_action(key: Key) -> StringName:
	match key:
		Key.MOVE_LEFT:
			return "move_left"
		Key.MOVE_RIGHT:
			return "move_right"
		Key.MOVE_UP:
			return "move_up"
		Key.MOVE_DOWN:
			return "move_down"
	return "unknown"


static func get_key(action: StringName) -> Combo.Key:
	match action:
		"move_left":
			return Key.MOVE_LEFT
		"move_right":
			return Key.MOVE_RIGHT
		"move_up":
			return Key.MOVE_UP
		"move_down":
			return Key.MOVE_DOWN
	return Key.NONE
