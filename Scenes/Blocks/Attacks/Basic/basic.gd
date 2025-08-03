extends Node2D

var MAX_TARGETS = 1
var targets = []
var projectile
var newProjectile

var unit

var augments
var delay = 5.0
var NUM_PROJECTILES = 1

@onready var timing = preload("res://scenes/Blocks/Attacks/Basic/spawner.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NUM_PROJECTILES = 1
	if augments != null:
		for x in augments:
			if x == "projectile":
				NUM_PROJECTILES += 1

	if projectile.get_state().get_node_name(0) == "spike":
		# create a projectile
		for x in range(NUM_PROJECTILES):
			newProjectile = projectile.instantiate()
			Global.battlefield.call_deferred("add_child", newProjectile)
			newProjectile.augments = augments
			call_deferred("test", newProjectile)
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
			# create a projectile
		newProjectile = projectile.instantiate()
		if "speed" in newProjectile:
			newProjectile.speed = 500
		if "target" in newProjectile:
			newProjectile.target = area.get_parent().get_parent()
			if unit != null:
				unit.target = area.get_parent().get_parent().global_position
		newProjectile.augments = augments
		Global.battlefield.call_deferred("add_child", newProjectile)
		call_deferred("test", newProjectile)
		
		for x in range(NUM_PROJECTILES):
			if x == 0:
				continue
			var custom_timer = timing.new()
			print(x)
			custom_timer.wait_time = delay / (NUM_PROJECTILES + 1) * x
			custom_timer.one_shot = true
			custom_timer.unit = unit
			custom_timer.augments = augments
			custom_timer.projectile = projectile
			Global.battlefield.add_child(custom_timer)
			custom_timer.start()

			
	queue_free()
	pass # Replace with function body.
	
func test(proj) -> void:
	proj.global_position = global_position
	if "origin" in proj:
		proj.origin= global_position
	if "set_direction" in proj:
		proj.set_direction()
	pass # Replace with function body.
