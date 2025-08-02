extends Node2D
var block = null
var block2 = null
var currScript = null

func _ready() -> void:
	Global.editor = self
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if currScript != null:
		block = area.get_parent()
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	block = null
	pass # Replace with function body.

func _process(delta: float) -> void:
	# load scene
	
	if Global.selectedUnit != null && currScript != Global.unitScripts[Global.selectedUnit]:
		if currScript != null:
			currScript.scale = Vector2(0, 0)
		currScript = Global.unitScripts[Global.selectedUnit]
		# set scene as editor
		Global.editor = currScript
		if currScript in get_children():
			currScript.scale = Vector2(1, 1)
		else:
			add_child(currScript)

	
	if block != null && !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && block.location == "inventory":
		block.reparent(currScript)
		block.location = "editor"
		block.z_index = 0
		block.unit = Global.selectedUnit
		if block in get_children():
			move_child(block, 4)
		block.scale = Vector2(1.5, 1.5)
		
	if block2 != null && !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && block2.location == "editor":
		block2.location = "inventory"
		block2.z_index = 3
		block2.unit = null
		Global.inventory.append(block2)
		block2.scale = Vector2(1.0, 1.0)


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && Global.currBlock == area.get_parent() && area.get_parent().count == 0 && area.get_parent().storable:
		block2 = area.get_parent()
	pass # Replace with function body.


func _on_area_2d_2_area_exited(area: Area2D) -> void:
	block2 = null
	pass # Replace with function body.
