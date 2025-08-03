extends Node2D

var MAX_TARGETS = 1
var NUM_PROJECTILES = 3
var MAX_ANGLE = deg_to_rad(20.0)

var targets = []
var projectile
var unit
var augments
var delay = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NUM_PROJECTILES = 3
	if augments != null:
		for x in augments:
			if x == "projectile":
				NUM_PROJECTILES += 1
	if projectile.get_state().get_node_name(0) == "spike":
		# create a projectile
		for x in range(NUM_PROJECTILES):
			randomize()
			var angleShift = randf_range(-MAX_ANGLE, MAX_ANGLE)
			print(angleShift)
			# create a projectile
			var newProjectile = projectile.instantiate()
			if "speed" in newProjectile:
				newProjectile.speed = 1000
			Global.battlefield.call_deferred("add_child", newProjectile)
			call_deferred("test", newProjectile, angleShift)
		queue_free()
	pass

func _fire(mods: Array):
	pass


func _on_timer_timeout() -> void:
	# detected no enemies so die
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	# detect if buggies are in radius
	if area.get_parent().get_parent() && targets.size() < MAX_TARGETS && area.get_parent().get_parent().is_in_group("bugs"):
		targets.append(area.get_parent().get_parent())
		
		for x in range(NUM_PROJECTILES):
			randomize()
			var angleShift = randf_range(-MAX_ANGLE, MAX_ANGLE)
			# create a projectile
			var newProjectile = projectile.instantiate()
			if "speed" in newProjectile:
				newProjectile.speed = 1000
			if "target" in newProjectile:
				newProjectile.target = area.get_parent().get_parent()
				unit.target = area.get_parent().get_parent().global_position
			newProjectile.dmg /= NUM_PROJECTILES
			Global.battlefield.call_deferred("add_child", newProjectile)
			call_deferred("test", newProjectile, angleShift)
		
		queue_free()
	pass # Replace with function body.


func test(proj, angle) -> void:
	proj.augments = augments
	proj.global_position = global_position
	if "origin" in proj:
		proj.origin= global_position
	if "set_direction" in proj:
		proj.set_direction()
		proj.dir = proj.dir.rotated(angle)
		
		
	pass # Replace with function body.
