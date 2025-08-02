extends Node2D

var target
var speed

var dir

var augments


func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()
	
func set_pos(pos):
	set_direction()
	
func _process(delta: float) -> void:
	if dir != null:
		global_position += dir * speed * delta  * Global.timeScale * Global.timeScale
