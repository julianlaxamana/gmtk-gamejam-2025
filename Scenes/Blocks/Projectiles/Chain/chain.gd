extends Node2D

var targets = []
var hit = []
var MAX_TARGETS = 3
var dir
var speed
var origin
var damage = Global.baseDmg["chain"]
var dmg = damage
var scaleBolt = 1.0

var bolt
var target

var augments
# Called when the node enters the scene tree for the first time.
@onready var projectile = preload("res://scenes/Blocks/Projectiles/Chain/chain.tscn")
@onready var boltScn = preload("res://scenes/Blocks/Projectiles/Chain/bolt.tscn")
func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()
var baseScale
func _ready():
	$Node2D/Timer.start()
	baseScale = scale
	if bolt == null:
		bolt = boltScn.instantiate()
		Global.battlefield.add_child(bolt)
		
	
	pass # Replace with function body.

var explode = false

var fire = false
var ice = false
var slow = false
var poison = false
var explosion = preload("res://scenes/Blocks/Projectiles/Explode/Explode.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scaleBolt = 1.0
	if augments != null:
		for x in augments:
			if x == "pierce":
				MAX_TARGETS += 1
			elif x == "big":
				scale = baseScale * 1.75
				dmg = damage * 1.25
				scaleBolt = 1.75
			elif x == "explode":
				explode = true
			elif x == "fire":
				fire = true
			elif x == "ice":
				fire = true
			elif x == "slow":
				fire = true	
			elif x == "slow":
				poison = true	
			

	global_position = origin + dir * 50
	pass
var a = true
func _on_timer_timeout() -> void:
	if explode && a != true && targets.back() != null:
		var explode = explosion.instantiate()
		Global.battlefield.add_child(explode)
		explode.global_position = targets.back().global_position
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

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if a && area.get_parent().get_parent() && area.get_parent().get_parent().is_in_group("bugs") && !area.get_parent().get_parent() in hit && hit.size() < MAX_TARGETS:
		# create a projectile
		a = false
		var newProjectile = projectile.instantiate()
		newProjectile.hit = hit
		newProjectile.bolt = bolt
		bolt.scale *= scaleBolt
		newProjectile.hit.append(area.get_parent().get_parent())
		newProjectile.targets.append(area.get_parent().get_parent())
		if "speed" in newProjectile:
			newProjectile.speed = 500
		if "target" in newProjectile:
			newProjectile.target = area.get_parent().get_parent()
		Global.battlefield.call_deferred("add_child", newProjectile)
		call_deferred("test", newProjectile, Vector2(0, 0), area.get_parent().get_parent().global_position)
		
		area.get_parent().get_parent().health -= dmg
		
	pass # Replace with function body.
