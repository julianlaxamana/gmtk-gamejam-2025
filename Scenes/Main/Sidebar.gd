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
	if Global.selectedBlock == null:
		$Button2.visible = false
		$Button4.visible = false
		
	elif Global.selectedUnit != null:
		$Button2.visible = false
		$Button4/Label5.text = "unit_level = " + str(Global.selectedUnit.level) + "\ncurrent_blocks = " + str(Global.selectedUnit.currentBlocks) + "\nmax_blocks = " + str(Global.selectedUnit.maxBlocks)
		$Button4/Label3.text = str(int(Global.selectedUnit.level * Global.shopBase["upgrade"] * Global.shopScales["upgrade"]))
		$Button4.visible = true
	else: 
		$Button2/Label3.text = str(int(Global.shopBase["unit"] * Global.shopScales["unit"]))
		$Button2.visible = true
		$Button4.visible = false
		
		
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
	

var a = true
func _on_button_2_mouse_exited() -> void:
	if a:
		Global.disableMouse = false
	pass # Replace with function body.


func _on_button_2_button_down() -> void:
	if Global.bits >= int(int(Global.shopBase["unit"] * Global.shopScales["unit"])):
		Global.bits -= int(int(Global.shopBase["unit"] * Global.shopScales["unit"]))
	else:
		return
	a = false
	Global.disableMouse = true
	Global.battlefield.grid.placeUnit()
	await get_tree().create_timer(0.1).timeout 
	a = true
	pass # Replace with function body.


func _on_button_4_button_down() -> void:
	if Global.bits >= int(int(Global.shopBase["upgrade"] * Global.shopScales["upgrade"] * Global.selectedUnit.level)):
		Global.bits -= int(int(Global.shopBase["upgrade"] * Global.shopScales["upgrade"] * Global.selectedUnit.level))		
	else:
		return
	Global.selectedUnit.level += 1
	pass # Replace with function body.


func _on_audio_stream_player_finished() -> void:
	$"../../BugHit".play()
	pass # Replace with function body.
