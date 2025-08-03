extends Node2D


func _ready():
	$Timer.start()
	
func _on_timer_timeout() -> void:
	print("death")
	queue_free()
	pass # Replace with function body.
