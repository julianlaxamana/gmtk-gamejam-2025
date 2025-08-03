extends Node2D

var targets = []
func _ready():
	$Timer.start()
	$Timer2.start()
func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.

func dmg():
	for bug in targets:
		if bug != null:
			bug.health -= 10.0
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() && area.get_parent().get_parent().is_in_group("bugs"):
		targets.append(area.get_parent().get_parent())
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	dmg()
	pass # Replace with function body.
