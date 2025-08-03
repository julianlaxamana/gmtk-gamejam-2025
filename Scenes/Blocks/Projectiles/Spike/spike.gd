extends Node2D

var targets = []
var MAX_TARGETS = 1
var dir = Vector2(0,0)
var speed
var origin
var getPos = true
var target
var pos
var damage = Global.baseDmg["chain"]
var dmg = damage
# Called when the node enters the scene tree for the first time.
var augments

var baseScale
var explosion = preload("res://scenes/Blocks/Projectiles/Explode/Explode.tscn")

# Called when the node enters the scene tree for the first time.
var explode = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play(0.0)
	baseScale = scale
	pass # Replace with function body.

var fire = false
var ice = false
var slow = false
var poison = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
				ice = true
			elif x == "slow":
				slow = true	
			elif x == "poison":
				poison = true
				
	if getPos:
		var thing = randf_range(-75.0, 75.0)
		var closestOffset = Global.path_node.curve.get_closest_offset(Global.path_node.to_local(global_position + dir * 50.0))
		pos = Global.path_node.to_global(Global.path_node.curve.sample_baked(closestOffset + thing))
		if (global_position - Global.path_node.to_global(Global.path_node.curve.sample_baked(closestOffset))).length() > 500.0:
			queue_free()
		getPos = false
	global_position = lerp(global_position, pos, 2 * delta * Global.timeScale)
	
	if targets.size() == MAX_TARGETS:
		if explode:
			var explode = explosion.instantiate()
			Global.battlefield.add_child(explode)
			explode.global_position = targets.back().global_position
		queue_free()
			
	#global_position = origin + dir * 50
	pass

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.

func _on_area_2d_area_entered(area: Area2D) -> void:
#	 #get buggys that are in radius
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
#		queue_free()
	pass # Replace with function body.
