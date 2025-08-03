extends Node2D
var blockCount = 6

func _ready() -> void:
	$"Action Block".holey = false
	$"Action Block".functionName = "// UNIT 01"
	$"Action Block".location = "editor"
	$"Action Block".z_index = 0
	$"Action Block".unit = Global.selectedUnit
	$"Action Block".storable = false
	
	$"Action Block2".functionName = "2.0"
	$"Action Block2".variable = 2.0
	$"Action Block2".location = "editor"
	$"Action Block2".z_index = 0
	$"Action Block2".unit = Global.selectedUnit
	$"Action Block2".storable = false
	
	$"Action Block3".functionName = "0.5"
	$"Action Block3".variable = 0.5
	$"Action Block3".z_index = 0
	$"Action Block3".location = "editor"
	$"Action Block3".unit = Global.selectedUnit
	$"Action Block3".storable = false
	
	$"Loop Block2".functionName = "set_range("
	$"Loop Block2".unit = Global.selectedUnit
	$"Loop Block2".z_index = 0
	$"Loop Block2".location = "editor"
	$"Loop Block2".task = func(thing):
		if thing.get_child(9).get_child_count() == 1 && "variable" in thing.get_child(9).get_child(0):
			thing.unit.radius = thing.get_child(9).get_child(0).variable
			#print(thing.owner.range)
	$"Loop Block2".bottomText = ")"
	$"Loop Block2".storable = false
	
	$"Loop Block3".functionName = "set_delay("
	$"Loop Block3".unit = Global.selectedUnit
	$"Loop Block3".bottomText = ")"
	$"Loop Block3".z_index = 0
	$"Loop Block3".location = "editor"
	$"Loop Block3".storable = false

	$"Loop Block".startTimer()
	$"Loop Block".location = "editor"
	$"Loop Block".z_index = 0
	$"Loop Block".unit = Global.selectedUnit
	$"Loop Block".storable = false
