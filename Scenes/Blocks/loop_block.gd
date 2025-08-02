extends Node2D

@onready var text = $Top/Text
@onready var top = $Top/Top
@onready var hole = $Top/Hole
@onready var end = $Top/End
@onready var connector = $Top/Connector
@onready var side = $Side
@onready var bottom = $Bottom

@onready var outside = $outside
@onready var inside = $inside

@onready var click = $click
@onready var topArea = $ClickArea/Top
@onready var sideArea = $ClickArea/Side
@onready var bottomArea = $ClickArea/Bottom

@onready var nubArea = $NubArea3
@onready var nubArea2 = $NubArea2
@onready var holeArea = $HoleArea
var state = "off"
var offset
var functionName = "while (true) {"
var bottomText = "sleep(delay) }"
var areaName
const horizScale = 1.1
var pressed = false

var attached = false
var count = 0; 

var location = "shop"
var type = "loop"
var pos
var holey = true
var loopBlock = null
var entered = false
var delay = 0.5
var unit
var task := func (thing):
		pass

var test := func (obj):
	pass
var variable

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
func startTimer():
	$Timer.start()
func update():
	# Dynamic changing size of block based on text
	top.scale.x = (text.size.x * text.scale.x / top.region_rect.size.x) * horizScale
	var topPixelSize = top.region_rect.size.x * top.scale.x
	var connectorPixelSize = connector.region_rect.size.x 
	end.position.x = topPixelSize + connectorPixelSize + hole.region_rect.size.x * hole.scale.x * 0.9
	
	# Area Scales
	topArea.shape.size.x = (connector.position.x + end.position.x + end.scale.x * end.region_rect.size.x * horizScale)
	
	# Change click boxes positions
	topArea.position.x = connector.position.x + topArea.shape.size.x / 2.0
	bottomArea.position.x = bottom.position.x + bottom.region_rect.size.x * bottom.scale.x / 2.0
	sideArea.position.x = connector.position.x + connector.region_rect.size.x * connector.scale.x / 2.0
	side.scale.y = 2.2 * (count) + .1
	
	if holey:
		hole.region_rect.size = Vector2(8, 7)
		hole.region_rect.position = Vector2(3, 20)
	else:
		hole.region_rect.size = Vector2(8, 7)
		hole.region_rect.position = Vector2(10.0, 20)
		holeArea.scale = Vector2(0, 0)
	$Top/Text.text = functionName
	$Bottom/Text.text = bottomText
		
	
func _ready():
	update()

func _process(delta: float) -> void:
	if unit != Global.selectedUnit && location == "editor":
		visible = false
		return
	if location == "editor":
		visible = true
	$Timer.wait_time = delay
	task.call(self)
	count = $inside.count
	attached = $inside.attached
	$Top/Text.text = functionName
	$Bottom/Text.text = bottomText
	
	nubArea.monitorable = !inside.attached
	nubArea2.monitorable = !outside.attached
	
	if abs(side.scale.y - ( 2.2 * (count + 1))) > 0.01: 
		side.scale.y = lerp(side.scale.y, 2.2 * (count) + .1, delta * 3)
	else:
		side.scale.y = 2.2 * (count) + .2
	
	if "count" in get_parent():
		get_parent().count = count + 2.2
	sideArea.position.y = side.position.y + side.scale.y * side.region_rect.size.y / 2
	
	sideArea.shape.size.y = (side.position.y + sideArea.position.y) * 3
	bottom.position.y = side.scale.y * side.region_rect.size.y - side.position.y - bottom.region_rect.size.y * bottom.scale.y
	bottomArea.position.y = bottom.position.y - bottomArea.shape.size.y / 2
	nubArea2.position.y = bottom.position.y - 4.8
	$outside.position.y = nubArea2.position.y - 25
	
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
		
	if $outside.get_child_count() > 1:
		$outside.get_child(1).reparent(Global.editor)
	if $inside.get_child_count() > 1:
		$inside.get_child(1).reparent(Global.editor)
	
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
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && state == "dragging":
		var mouse_position_global = get_viewport().get_mouse_position()
		position = mouse_position_global + offset
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && entered == true:
		# derek wu - dont tap the galse
		click.pitch_scale = randf_range(0.9, 1.1)
		click.play(0.0)
		self.reparent(loopBlock)

		if loopBlock != null:
			if areaName == "NubArea2":
				loopBlock.outside.attached = true
			elif areaName == "NubArea3":
				loopBlock.inside.attached = true
			else:
				loopBlock.attached = true 

		if "type" in get_parent() and get_parent().type == "loop" && areaName == "NubArea2":
			self.reparent(get_parent().get_child(10))
			pos = Vector2(0, 55)
		elif "type" in get_parent() and get_parent().type == "loop":
			self.reparent(get_parent().get_child(9))
			pos = Vector2(14.0, 25.5)
		elif "type" in get_parent() and get_parent().type == "action":
			pos = Vector2(-2, 25.5)
			
		holeArea.monitoring = false
		
	if state == "on":
		Global.cursorGrab = false
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && state == "dragging":
		state = "on"
		#Global.cursorGrab = false
	
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
	if location == "editor":
		loopBlock = area.get_parent()
		areaName = area.name
		entered = true
	pass # Replace with function body.


func _on_hole_area_area_exited(area: Area2D) -> void:
	entered = false
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	if $inside.get_child_count() == 1:
		$inside.get_child(0).test.call($inside.get_child(0))
		print("shoot!")
	pass # Replace with function body.
