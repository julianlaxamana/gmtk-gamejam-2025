extends Node2D

var targets = []
var MAX_TARGETS = 1
var dir
var speed
var origin
var damage

var target
# Called when the node enters the scene tree for the first time.

func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = origin + dir * 50
	pass

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.

func _on_area_2d_area_entered(area: Area2D) -> void:
	 #get buggys that are in radius
	if area.get_parent().get_parent() && targets.size() < MAX_TARGETS && area.get_parent().get_parent().is_in_group("bugs"):
		targets.append(area.get_parent().get_parent())
		
		
		# bug hit
		#for bug in targets:
		#	bug.health -= damage
		#	pass
		
		queue_free()
	pass # Replace with function body.
