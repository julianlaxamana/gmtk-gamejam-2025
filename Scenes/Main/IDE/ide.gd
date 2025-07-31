extends CanvasLayer
func _on_sub_viewport_container_mouse_entered() -> void:
	Global.disableMouse = true
	pass # Replace with function body.


func _on_sub_viewport_container_mouse_exited() -> void:
	Global.disableMouse = false
	pass # Replace with function body.
