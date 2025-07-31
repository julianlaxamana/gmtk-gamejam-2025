extends Node2D
@onready var nubArea = $NubArea
@onready var holeArea = $HoleArea

var state = "off"
var offset

var pressed = false
var entered = false

var attached = false
var count = 0; 

var pos;
var canvas;
var loopBlock: Node2D
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
		
func _ready():
	canvas = get_parent()
	print("read")

func _process(delta: float) -> void:
	nubArea.monitorable = !attached
	if holeArea.monitoring == false:
		self.position = lerp(self.position, pos, delta * 20)
	if "count" in get_parent():
		get_parent().count = count + 1
	
	
	if get_child_count() > 7:
		get_child(7).reparent(get_tree().root)
	
	# Dynamic Dragging
	if pressed && state == "on" && Global.cursorGrab == false:
		print("hi")
		holeArea.monitoring = true
		if "attached" in get_parent():
			get_parent().attached = false;
			get_parent().count = 0;
		self.reparent(canvas)
		var mouse_position_global = get_viewport().get_mouse_position()
		offset = position - mouse_position_global
		state = "dragging"
		Global.cursorGrab = true
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && state == "dragging":
		var mouse_position_global = get_viewport().get_mouse_position()
		position = mouse_position_global + offset
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && state == "dragging":
		state = "on"
		Global.cursorGrab = false
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && entered == true:
		self.reparent(loopBlock)
		if loopBlock != null:
			loopBlock.attached = true
		if get_parent().name == "Loop Block":
			pos = Vector2(14.0, 25.5)
			
		elif get_parent().name.contains("Action Block"):
			pos = Vector2(1.1, 25.5)
			
		holeArea.monitoring = false
		
	if state == "on":
		Global.cursorGrab = false
		
	pressed = false;

func _on_click_area_mouse_entered() -> void:
	state = "on"
	pass # Replace with function body.

func _on_click_area_mouse_exited() -> void:
	state = "off"
	pass # Replace with function body.

func _on_hole_area_area_entered(area: Area2D) -> void:
	loopBlock = area.get_parent()
	entered = true
	pass # Replace with function body.


func _on_hole_area_area_exited(area: Area2D) -> void:
	loopBlock = null
	entered = false
	pass # Replace with function body.
