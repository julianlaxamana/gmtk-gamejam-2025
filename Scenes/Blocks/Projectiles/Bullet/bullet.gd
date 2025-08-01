extends Node2D

var targets = []
var MAX_TARGETS = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	# get buggys that are in radius
	if area.get_parent() && targets.size() < MAX_TARGETS:
		targets.append(area.get_parent().get_parent())
		queue_free()
	pass # Replace with function body.
