extends Control
var open = false
@onready var editor = $Editor
@onready var button = $Button

func _on_button_button_down() -> void:
	open = !open
	pass # Replace with function body.

func _process(delta: float) -> void:
	if open:
		position.x = lerp(position.x, -360.0, delta * 5)
		editor.offset.x = lerp(editor.offset.x, -360.0, delta * 5)
		button.text = ">"
	else:
		position.x = lerp(position.x, 0.0, delta * 5)
		editor.offset.x = lerp(editor.offset.x, 0.0, delta * 5)
		button.text = "<"
