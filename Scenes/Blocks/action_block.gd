class_name Projectile extends Node2D
@onready var nubArea = $NubArea
@onready var holeArea = $HoleArea
@onready var click = $click
@onready var hole = $BG/Hole

@onready var funct = $Function

var functionName = ""

var state = "off"
var offset
var pressed = false
var entered = false
var attached = false
var count = 0; 
var pos;
var loopBlock: Node2D
var areaName

var location = ""
var type = "action"
var typeOf = ""

var variable
var augments
var unit

var holey = true
var storable = true
func _ready() -> void:
	if holey:
		hole.region_rect.size = Vector2(8, 7)
		hole.region_rect.position = Vector2(3, 20)
	else:
		hole.region_rect.size = Vector2(8, 7)
		hole.region_rect.position = Vector2(10.0, 20)
		holeArea.scale = Vector2(0, 0)
		
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed

func _process(delta: float) -> void:
	if unit != Global.selectedUnit && location == "editor":
		visible = false
		return
	if location == "editor":
		visible = true
	
	if holey:
		hole.region_rect.size = Vector2(8, 7)
		hole.region_rect.position = Vector2(3, 20)
	else:
		hole.region_rect.size = Vector2(8, 7)
		hole.region_rect.position = Vector2(10.0, 20)
		holeArea.scale = Vector2(0, 0)
		
		
	funct.text = functionName
	nubArea.monitorable = !attached
	if location == "inventory":
		if sqrt((self.position.x - pos.x)**2 + (self.position.y - pos.y)**2) < 0.1:
			self.position = pos
		else:
			self.position = lerp(self.position, pos, delta * 10)
	if holeArea.monitoring == false && holeArea.monitorable == true:
		if sqrt((self.position.x - pos.x)**2 + (self.position.y - pos.y)**2) < 0.1:
			self.position = pos
		else:
			self.position = lerp(self.position, pos, delta * 20)
	if "count" in get_parent():
		get_parent().count = count + 1
	
	if get_child_count() > 8:
		get_child(8).reparent(Global.editor)
	
	if typeOf == "augment":
		augments = variable.duplicate()
		if get_child_count() == 7 && get_child(6) != null && get_child(6).typeOf == "augment":
			augments.append_array(get_child(6).augments)
		
		
	# Dynamic Dragging
	if pressed && state == "on" && Global.cursorGrab == false:
		holeArea.monitoring = true
		if "attached" in get_parent():
			get_parent().attached = false;
			get_parent().count = 0;
		if location == "editor":
			self.reparent(Global.editor)
			
		var mouse_position_global = get_viewport().get_mouse_position()
		offset = position - mouse_position_global
		state = "dragging"
		Global.cursorGrab = true
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && state == "dragging":
		state = "on"
		Global.cursorGrab = false
	elif state == "dragging":
		Global.currBlock = self
		var mouse_position_global = get_viewport().get_mouse_position()
		position = mouse_position_global + offset
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && entered == true:
		click.pitch_scale = randf_range(0.9, 1.1)
		click.play(0.0)
		self.reparent(loopBlock)

		if loopBlock != null:
			loopBlock.attached = true
		
		if "type" in get_parent() and get_parent().type == "loop" && areaName == "NubArea2":
			self.reparent(get_parent().get_child(10))
			pos = Vector2(2, 55)
		elif "type" in get_parent() and get_parent().type == "loop":
			self.reparent(get_parent().get_child(9))
			pos = Vector2(14.0, 25.5)
			
			
		elif "type" in get_parent() and get_parent().type == "action":
			pos = Vector2(0.0, 25.5)
			
		holeArea.monitoring = false
		
	if state == "on":
		Global.cursorGrab = false
		
	pressed = false;

func _on_click_area_mouse_entered() -> void:
	if state != "dragging":
		state = "on"
	pass # Replace with function body.

func _on_click_area_mouse_exited() -> void:
	if state != "dragging":
		state = "off"
	pass # Replace with function body.

func _on_hole_area_area_entered(area: Area2D) -> void:
	if location == "editor":
		loopBlock = area.get_parent()
		areaName = area.name
		entered = true
	pass # Replace with function body.


func _on_hole_area_area_exited(area: Area2D) -> void:
	entered = false
	pass # Replace with function body.
