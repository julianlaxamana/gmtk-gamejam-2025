extends Node2D

var target
var speed

var dir
func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()
	
func _process(delta: float) -> void:
	global_position += dir * speed * delta 
