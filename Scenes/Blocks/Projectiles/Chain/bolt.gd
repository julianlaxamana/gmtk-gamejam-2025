extends Node2D
var test = []
var augments

func _draw():
	var thing = PackedVector2Array()
	for i in range(test.size() - 1):
		draw_line(test[i], test[i + 1], Color.WHITE_SMOKE, 5)
		
	for x in test:
		draw_circle(x, 5, Color.STEEL_BLUE)
	
func _process(delta):
	queue_redraw()


func _on_timer_timeout() -> void:
	print("hi")
	queue_free()
	pass # Replace with function body.
