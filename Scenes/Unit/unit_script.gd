extends Node2D

func _ready() -> void:
	$"Action Block".holey = false
	$"Action Block".functionName = "// UNIT 01"
	$"Action Block".unit = Global.selectedUnit
	
	$"Action Block2".functionName = "2.0"
	$"Action Block2".variable = 2.0
	$"Action Block2".location = "editor"
	$"Action Block2".unit = Global.selectedUnit
	
	$"Action Block3".functionName = "0.5"
	$"Action Block3".variable = 0.5
	$"Action Block3".location = "editor"
	$"Action Block3".unit = Global.selectedUnit
	
	$"Loop Block2".functionName = "set_range("
	$"Loop Block2".unit = Global.selectedUnit
	$"Loop Block2".task = func(thing):
		if thing.get_child(9).get_child_count() == 1 && "variable" in thing.get_child(9).get_child(0):
			thing.unit.radius = thing.get_child(9).get_child(0).variable
			#print(thing.owner.range)
	$"Loop Block2".bottomText = ")"
	
	$"Loop Block3".functionName = "set_delay("
	$"Loop Block3".unit = Global.selectedUnit
	$"Loop Block3".bottomText = ")"
	
	
	$"Loop Block4".functionName = "radial_shoot ("
	$"Loop Block4".unit = Global.selectedUnit
	$"Loop Block4".variable = preload("res://scenes/Blocks/Attacks/Radial/radial.tscn")
	$"Loop Block4".test = func (obj):
		if obj.get_child(9).get_child_count() == 1 && "variable" in obj.get_child(9).get_child(0):
			var attack = obj.variable.instantiate()
			attack.projectile = obj.get_child(9).get_child(0).variable
			print(obj.get_child(9).get_child(0).variable)
			obj.unit.add_child(attack)
			#projectile.reparent(obj.unit)
		pass
	$"Loop Block4".bottomText = ")"
	$"Loop Block5".functionName = "basic_shoot ("
	$"Loop Block5".unit = Global.selectedUnit
	$"Loop Block5".variable = preload("res://scenes/Blocks/Attacks/Basic/basic.tscn")
	$"Loop Block5".test = func (obj):
		if obj.get_child(9).get_child_count() == 1 && "variable" in obj.get_child(9).get_child(0):
			var attack = obj.variable.instantiate()
			attack.unit = obj.unit
			attack.projectile = obj.get_child(9).get_child(0).variable
			obj.unit.add_child(attack)
			#projectile.reparent(obj.unit)
		pass
	$"Loop Block5".bottomText = ")"
	
	$"Loop Block".startTimer()
	$"Loop Block".unit = Global.selectedUnit
	
	$"Action Block4".functionName = "\"homing\""
	$"Action Block4".variable = preload("res://scenes/Blocks/Projectiles/Spike/spike.tscn")
	$"Action Block4".location = "editor"
	$"Action Block4".unit = Global.selectedUnit
	
	$"Action Block5".functionName = "\"melee\""
	$"Action Block5".variable = preload("res://scenes/Blocks/Projectiles/Melee/melee.tscn")
	$"Action Block5".location = "editor"
	$"Action Block5".unit = Global.selectedUnit
