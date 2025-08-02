extends Node2D

var targets = []
var MAX_TARGETS = 1
var dir = Vector2(0,0)
var speed
var origin
var getPos = true
var target
var pos
# Called when the node enters the scene tree for the first time.
var augments

func _ready():
	#global_position =Global.path_node.to_global(closestOffset)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if getPos:
		var thing = randf_range(-75.0, 75.0)
		var closestOffset = Global.path_node.curve.get_closest_offset(Global.path_node.to_local(global_position + dir * 50.0))
		pos = Global.path_node.to_global(Global.path_node.curve.sample_baked(closestOffset + thing))
		if (global_position - Global.path_node.to_global(Global.path_node.curve.sample_baked(closestOffset))).length() > 500.0:
			queue_free()
		getPos = false
	global_position = lerp(global_position, pos, 2 * delta)
	#global_position = origin + dir * 50
	pass

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.

#func _on_area_2d_area_entered(area: Area2D) -> void:
#	 #get buggys that are in radius
#	if area.get_parent().get_parent() && targets.size() < MAX_TARGETS && area.get_parent().get_parent().is_in_group("bugs"):
#		targets.append(area.get_parent().get_parent())
#		queue_free()
#	pass # Replace with function body.
