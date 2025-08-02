extends HSlider



func _on_value_changed(value: float) -> void:
	$Label3.text = str(value) + "x" 
	Global.timeScale = value
	pass # Replace with function body.
