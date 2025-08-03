extends Node2D

var MAX_TARGETS = 1
var NUM_PROJECTILES = 1
var MAX_ANGLE = deg_to_rad(10.0)

var target
var projectile

var unit

var augments

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if augments != null:
		for x in augments:
			if x == "projectile":
				NUM_PROJECTILES += 1
	if projectile.get_state().get_node_name(0) == "spike":
		# create a projectile
		var newProjectile = projectile.instantiate()
		Global.battlefield.call_deferred("add_child", newProjectile)
		call_deferred("test", newProjectile, 0)
		queue_free()
	pass
	unit.enable_target()
	pass

func _fire(mods: Array):
	pass


func _on_timer_timeout() -> void:
	unit.disable_target()
	# detected no enemies so die
	queue_free()

func test(proj, angle) -> void:
	proj.global_position = global_position
	if "origin" in proj:
		proj.origin= global_position
	if "set_direction" in proj:
		proj.set_direction()
		proj.dir = proj.dir.rotated(angle)
		
		
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	if projectile.get_state().get_node_name(0) == "spike":
		return
	randomize()
	var angleShift = randf_range(-MAX_ANGLE, MAX_ANGLE)
	
	# create a projectile
	var newProjectile = projectile.instantiate()
	
	if "speed" in newProjectile:
		newProjectile.speed = 1000
	if "target" in newProjectile:
		newProjectile.target = unit.get_target()
		unit.target = unit.get_target().global_position
		
	Global.battlefield.call_deferred("add_child", newProjectile)
	call_deferred("test", newProjectile, angleShift)
		
	pass # Replace with function body.
