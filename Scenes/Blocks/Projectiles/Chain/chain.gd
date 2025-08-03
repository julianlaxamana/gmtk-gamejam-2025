extends Node2D

var targets = []
var hit = []
var MAX_TARGETS = 5
var dir
var speed
var origin

var bolt
var target

var augments
# Called when the node enters the scene tree for the first time.
@onready var projectile = preload("res://scenes/Blocks/Projectiles/Chain/chain.tscn")
@onready var boltScn = preload("res://scenes/Blocks/Projectiles/Chain/bolt.tscn")
func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()
	
func _ready():
	if bolt == null:
		bolt = boltScn.instantiate()
		Global.battlefield.add_child(bolt)
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
	if area.get_parent().get_parent() && targets.size() < 1 && area.get_parent().get_parent().is_in_group("bugs"):
		targets.append(area.get_parent().get_parent())
		hit.append(area.get_parent().get_parent())
	
	pass # Replace with function body.

func test(proj, dir, pos) -> void:
	proj.global_position = pos
	bolt.test.append(position)
	if "origin" in proj:
		proj.origin= pos
		
	if "dir" in proj:
		print(dir)
		proj.dir = dir
		
	pass # Replace with function body.

var a = true
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	print(hit.size())
	if a && area.get_parent().get_parent() && area.get_parent().get_parent().is_in_group("bugs") && !area.get_parent().get_parent() in hit && hit.size() < MAX_TARGETS:
		# create a projectile
		a = false
		var newProjectile = projectile.instantiate()
		newProjectile.hit = hit
		newProjectile.bolt = bolt
		newProjectile.hit.append(area.get_parent().get_parent())
		newProjectile.targets.append(area.get_parent().get_parent())
		if "speed" in newProjectile:
			newProjectile.speed = 500
		if "target" in newProjectile:
			newProjectile.target = area.get_parent().get_parent()
		Global.battlefield.call_deferred("add_child", newProjectile)
		call_deferred("test", newProjectile, Vector2(0, 0), area.get_parent().get_parent().global_position)
		queue_free()
		
		
	pass # Replace with function body.
