extends Node2D
var bought = false
var up = false
func _on_button_button_down() -> void:
	bought = true
	Global.inventory.append($"Button/Action Block")
	print(Global.inventory)
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if bought:
		if !up:
			scale = lerp(scale, Vector2(1.2, 1.2), delta * 8)
		else:
			scale = lerp(scale, Vector2(0, 0), delta * 8)
			
		if scale > Vector2(1.16, 1.16):
			up = true
	
