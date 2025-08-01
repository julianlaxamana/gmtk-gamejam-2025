extends Node2D
var block = null
var currScript = null

func _ready() -> void:
	Global.editor = self
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	block = area.get_parent()
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	block = null
	pass # Replace with function body.

func _process(delta: float) -> void:
	# load scene
	if Global.selectedUnit != null && currScript != Global.unitScripts[Global.selectedUnit]:
		if currScript != null:
			remove_child(currScript)
		currScript = Global.unitScripts[Global.selectedUnit]
		# set scene as editor
		Global.editor = currScript
		add_child(currScript)

	
	if block != null && !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && block.location == "inventory":
		block.reparent(currScript)
		block.location = "editor"
		if block in get_children():
			move_child(block, 4)
		block.scale = Vector2(1.5, 1.5)
