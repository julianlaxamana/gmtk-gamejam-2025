extends Node2D

var target
var speed

var homingTarget

var dir
var augments

func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()

func set_pos(pos):
	set_direction()
	
func _process(delta: float) -> void:
	if homingTarget != null:
		dir = lerp(dir,  (homingTarget.global_position - global_position).normalized(), delta * Global.timeScale)
	if dir != null:
		global_position += dir * speed * delta * Global.timeScale


func _on_homing_area_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent().is_in_group("bugs"):
		homingTarget = area.get_parent().get_parent()
	pass # Replace with function body.
