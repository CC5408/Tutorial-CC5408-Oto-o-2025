extends Control
@onready var rich_text_label: RichTextLabel = $RichTextLabel


func _ready() -> void:
	set_process(false)
	await get_tree().create_timer(2).timeout
	set_process(true)

func _process(delta: float) -> void:
	rich_text_label.get_v_scroll_bar().value += 200 * delta
