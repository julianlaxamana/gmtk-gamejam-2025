extends Node2D

var target
var speed
var MAX_TARGETS = 1
var damage = 1.0
var homingTarget
var targets = []
var explode = false
var explosion = preload("res://scenes/Blocks/Projectiles/Explode/Explode.tscn")
var dir
var augments
var baseScale
# Called when the node enters the scene tree for the first time.
func _ready():
	baseScale = scale
	pass # Replace with function body.

func set_direction() -> void:
	dir = (target.global_position - global_position).normalized()

func set_pos(pos):
	set_direction()
	
func _process(delta: float) -> void:
	if augments != null:
		for x in augments:
			if x == "pierce":
				MAX_TARGETS += 1
			elif x == "big":
				scale = baseScale * 1.75
				damage = damage * 1.25
			elif x == "explode":
				explode = true
	if targets.size() == MAX_TARGETS && explode:
			var explode = explosion.instantiate()
			Global.battlefield.add_child(explode)
			explode.global_position = targets.back().global_position
			queue_free()
			
	if homingTarget != null:
		dir = lerp(dir,  (homingTarget.global_position - global_position).normalized(), delta * Global.timeScale)
	if dir != null:
		global_position += dir * speed * delta * Global.timeScale

func _on_timer_timeout() -> void:
	for bug in targets:
		pass
		
	queue_free()
	pass # Replace with function body.

func _on_area_2d_area_entered(area: Area2D) -> void:
	 #get buggys that are in radius
	if area.get_parent().get_parent() && targets.size() < MAX_TARGETS && area.get_parent().get_parent().is_in_group("bugs"):
		targets.append(area.get_parent().get_parent())
		

func _on_homing_area_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent().is_in_group("bugs"):
		homingTarget = area.get_parent().get_parent()
	pass # Replace with function body.
