extends Node2D
var bought = false
var up = false
var test = ["a", "b", "c"]
func _on_button_button_down() -> void:
	bought = true
	Global.inventory.append($"Button/Action Block")
	pass # Replace with function body.
	
func _ready() -> void:
	$"Button/Action Block".functionName = test[randi_range(0, 2)]
	
func _process(delta: float) -> void:
	if bought:
		if !up:
			scale = lerp(scale, Vector2(1.2, 1.2), delta * 8)
		else:
			scale = lerp(scale, Vector2(0, 0), delta * 8)
			
		if scale > Vector2(1.16, 1.16):
			up = true
	
