extends Timer
var projectile 
var augments
var unit
@onready var obj = preload("res://scenes/Blocks/Attacks/Basic/basic.tscn")
func _ready() -> void:
	self.timeout.connect(_on_timeout)
	
func spawn():
	var attack = obj.instantiate()
	attack.projectile = projectile
	attack.unit = unit
	if augments != null:
		var a = augments.duplicate()
		while ("projectile") in a:
			a.erase("projectile")
			
		attack.augments = a
	unit.add_child(attack)


func _on_timeout() -> void:
	spawn()
	queue_free()
	pass # Replace with function body.
