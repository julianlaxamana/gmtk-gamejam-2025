extends Node2D

var MAX_TARGETS = 1
var targets = []
@onready var projectile = preload("res://scenes/Blocks/Projectiles/Fireball/fireball_proj.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _fire(mods: Array):
	pass


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() && targets.size() < MAX_TARGETS && area.get_parent().get_parent().is_in_group("bugs"):
		targets.append(area.get_parent().get_parent())
		var newProjectile = projectile.instantiate()
		newProjectile.speed = 1000
		newProjectile.target = area.get_parent().get_parent()
		#print(area.get_parent().get_parent().position)
		Global.battlefield.add_child(newProjectile)
		newProjectile.global_position = global_position
		newProjectile.set_direction()
		
		print(newProjectile.position)
		queue_free()
	pass # Replace with function body.
