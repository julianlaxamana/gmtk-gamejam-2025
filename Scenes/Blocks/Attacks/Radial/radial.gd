extends Node2D

var MAX_TARGETS = 1
var NUM_PROJECTILES = 5

var targets = []
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
		for x in range(NUM_PROJECTILES):
			var direction = Vector2(sin(2 * PI * x / NUM_PROJECTILES), cos(2 * PI * x / NUM_PROJECTILES))
			# create a projectile
			var newProjectile = projectile.instantiate()
			if "speed" in newProjectile:
				newProjectile.speed = 1000

			Global.battlefield.call_deferred("add_child", newProjectile)
			call_deferred("test", newProjectile, direction)
		queue_free()
	pass
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
			var direction = Vector2(sin(2 * PI * x / NUM_PROJECTILES), cos(2 * PI * x / NUM_PROJECTILES))
			# create a projectile
			var newProjectile = projectile.instantiate()
			if "speed" in newProjectile:
				newProjectile.speed = 1000
			if "target" in newProjectile:
				newProjectile.target = area.get_parent().get_parent()
				unit.target = area.get_parent().get_parent().global_position
			newProjectile.dmg /= NUM_PROJECTILES
			Global.battlefield.call_deferred("add_child", newProjectile)
			call_deferred("test", newProjectile, direction)
		
		queue_free()
	pass # Replace with function body.


func test(proj, dir) -> void:
	proj.augments = augments
	proj.global_position = global_position
	if "origin" in proj:
		proj.origin= global_position
		
	if "dir" in proj:
		proj.dir = dir
		
	pass # Replace with function body.
