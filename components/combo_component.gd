class_name ComboComponent
extends Node

@export var combos: Array[Combo]
@export var delay : float = 1.0

var _current_combos: Array[Dictionary]
var _current_combos_index: Array[int]

#var _current_combos = Dictionary

var _actions: Array[StringName] # [move_left, move_right, ...]
func _ready() -> void:
	for i in Combo.Key.values():
		if i == 0:
			continue
		_actions.push_back(Combo.get_action(i))

func _input(event: InputEvent) -> void:
	for action in _actions:
		if Input.is_action_just_pressed(action):
			for i in combos.size():
				var combo = combos[i]
				if combo in _current_combos:
					var next_combo_index = _current_combos_index[i] + 1
					if combo.keys[next_combo_index] == Combo.get_key(action):
						if next_combo_index == combo.keys.size():
							Debug.log(combo.name)
							_current_combos = []
							_current_combos_index = []
						else:
							Debug.log("combo continue")
							_current_combos_index[i] += 1
					else:
						Debug.log("combo stop")
						
						var index = _current_combos.find(combo)
						_current_combos.remove_at(index)
						_current_combos_index.remove_at(index)
				else:
					if combo.keys.size() == 0:
						continue
					if combo.keys[0] == Combo.get_key(action):
						Debug.log("combo started")
						_current_combos.push_back(combo)
						_current_combos_index.push_back(0)
