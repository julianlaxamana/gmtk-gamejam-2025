extends Node2D

var targets = []
var MAX_TARGETS = 1
var dir
var speed
var origin
var damage = Global.baseDmg["chain"]
var dmg = damage

var augments

var target
# Called when the node enters the scene tree for the first time.

func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()
	
var baseScale
# Called when the node enters the scene tree for the first time.
func _ready():
	$Node2D/Timer.start()
	baseScale = scale
	pass # Replace with function body.


var explode = false
var fire = false
var ice = false
var slow = false
var poison = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MAX_TARGETS = 1
	if augments != null:
		for x in augments:
			if x == "pierce":
				MAX_TARGETS += 1
			elif x == "big":
				scale = baseScale * 1.75
				dmg = damage * 1.25
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
var explosion = preload("res://scenes/Blocks/Projectiles/Explode/Explode.tscn")

func _on_timer_timeout() -> void:
	for bug in targets:
		if explode:
			var explode = explosion.instantiate()
			Global.battlefield.add_child(explode)
			explode.global_position = bug.global_position
		
	queue_free()
	pass # Replace with function body.

func _on_area_2d_area_entered(area: Area2D) -> void:
	 #get buggys that are in radius
	if area.get_parent().get_parent() && targets.size() < MAX_TARGETS && area.get_parent().get_parent().is_in_group("bugs"):
		targets.append(area.get_parent().get_parent())
		area.get_parent().get_parent().health -= dmg
		if fire:
			area.get_parent().get_parent().apply_fire()
		if ice:
			area.get_parent().get_parent().apply_stun()
		if slow:
			area.get_parent().get_parent().apply_slow(20 / damage / 7.5)
		if poison:
			area.get_parent().get_parent().apply_poison()
		# bug hit
		#for bug in targets:
		#	bug.health -= damage
		#	pass
		
	pass # Replace with function body.
