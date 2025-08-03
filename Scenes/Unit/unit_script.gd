extends Node2D
var blockCount = 6

func _ready() -> void:
	$"Action Block".holey = false
	$"Action Block".functionName = "// UNIT 01"
	$"Action Block".location = "editor"
	$"Action Block".z_index = 100
	$"Action Block".nubType = 3
	$"Action Block".unit = Global.selectedUnit
	$"Action Block".storable = false
	
	randomize()
	var a = round(randf_range(1.5, 5))
	$"Action Block2".functionName = str(a)
	$"Action Block2".variable = a
	$"Action Block2".location = "editor"
	$"Action Block2".z_index = 100
	$"Action Block2".holeType = 4
	$"Action Block2".nubType = 7
	$"Action Block2".unit = Global.selectedUnit
	randomize()
	a = round(randf_range(0.5, 2.5))
	$"Action Block3".functionName = str(a)
	$"Action Block3".variable = a
	$"Action Block3".z_index = 100
	$"Action Block3".holeType = 5
	$"Action Block3".nubType = 7
	$"Action Block3".location = "editor"
	$"Action Block3".unit = Global.selectedUnit
	
	$"Loop Block2".functionName = "set_range("
	$"Loop Block2".unit = Global.selectedUnit
	$"Loop Block2".z_index = 100
	$"Loop Block2".holeType = 3
	$"Loop Block2".nubType1 = 4
	$"Loop Block2".nubType2 = 3
	$"Loop Block2".location = "editor"
	$"Loop Block2".task = func(thing):
		if thing.get_child(8).get_child_count() == 1 && "variable" in thing.get_child(8).get_child(0):
			thing.unit.radius = thing.get_child(8).get_child(0).variable
		else:
			thing.unit.radius
			#print(thing.owner.range)
	$"Loop Block2".bottomText = ")"
	$"Loop Block2".storable = false
	
	$"Loop Block3".functionName = "set_delay("
	$"Loop Block3".unit = Global.selectedUnit
	$"Loop Block3".bottomText = ")"
	$"Loop Block3".task = func(thing):
		if thing.get_child(8).get_child_count() == 1 && "variable" in thing.get_child(8).get_child(0):
			thing.unit.delay = thing.get_child(8).get_child(0).variable
	$"Loop Block3".holeType = 3
	$"Loop Block3".nubType1 = 5
	$"Loop Block3".nubType2 = 3
	$"Loop Block3".z_index = 100
	$"Loop Block3".location = "editor"
	$"Loop Block3".storable = false

	$"Loop Block".startTimer()
	$"Loop Block".location = "editor"
	$"Loop Block".z_index = 100
	$"Loop Block".holeType = 3
	$"Loop Block".nubType1 = 0
	$"Loop Block".nubType2 = 7
	$"Loop Block".unit = Global.selectedUnit
	$"Loop Block".storable = false
