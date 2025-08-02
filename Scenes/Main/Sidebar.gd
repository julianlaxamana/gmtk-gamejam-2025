extends Control
var open = true
@onready var editor = $Editor
@onready var button = $Button

func _on_button_button_down() -> void:
	open = !open
	pass # Replace with function body.
	
func _ready() -> void:
	position.x = -360.0
	editor.offset.x = -360
	
func _process(delta: float) -> void:
	if open:
		position.x = lerp(position.x, -360.0, delta * 5)
		editor.offset.x = lerp(editor.offset.x, -360.0, delta * 5)
		button.text = ">"
	else:
		position.x = lerp(position.x, 0.0, delta * 5)
		editor.offset.x = lerp(editor.offset.x, 0.0, delta * 5)
		button.text = "<"


func _on_shop_button_button_down() -> void:
	open = true
	pass # Replace with function body.






func _on_button_mouse_entered() -> void:
	Global.disableMouse = true
	pass # Replace with function body.


func _on_button_mouse_exited() -> void:
	Global.disableMouse = false
	pass # Replace with function body.


func _on_color_rect_mouse_entered() -> void:
	Global.disableMouse = true
	pass # Replace with function body.


func _on_color_rect_mouse_exited() -> void:
	Global.disableMouse = false
	pass # Replace with function body.


func _on_button_2_mouse_entered() -> void:
	Global.disableMouse = true
	pass # Replace with function body.
	


func _on_button_2_mouse_exited() -> void:
	Global.disableMouse = false
	pass # Replace with function body.
