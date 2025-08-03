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

@onready var insidevar = $inside
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
var storable = true

var holeType = 1

var nubType1 = 1
var nubType2 = 1
func setColor(color, obj):
	for child in obj.get_children():
		if "self_modulate" in child:
			child.self_modulate = color
			setColor(color, child)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
func startTimer():
	$Timer.start()
func update():
	# Dynamic changing size of block based on text
	
	#top.scale.x = (text.size.x * text.scale.x / top.region_rect.size.x) * horizScale
	#var topPixelSize = top.region_rect.size.x * top.scale.x
	#var connectorPixelSize = connector.region_rect.size.x 
	#end.position.x = topPixelSize + connectorPixelSize + hole.region_rect.size.x * hole.scale.x * 0.9
	
	# Area Scales
	topArea.shape.size.x = (connector.position.x + end.position.x + end.scale.x * end.region_rect.size.x * horizScale)
	
	# Change click boxes positions
	topArea.position.x = connector.position.x + topArea.shape.size.x / 2.0
	bottomArea.position.x = bottom.position.x + bottom.region_rect.size.x * bottom.scale.x / 2.0
	sideArea.position.x = connector.position.x + connector.region_rect.size.x * connector.scale.x / 2.0
	side.scale.y = 2.0 * (count) + .1
	
	if holey:
		hole.region_rect.position = Vector2(-2.0 + 128 * holeType, 134.995)
		hole.region_rect.size = Vector2(134.0, 107.0)
	else:
		hole.region_rect.position = Vector2(296.0, 7.0)
		hole.region_rect.size = Vector2(133, 107)
		holeArea.scale = Vector2(0, 0)
	
	$NubArea2/Nub2.region_rect.position = Vector2(-2.0 + 128.0 * nubType2, 288)
	$NubArea3/Nub2.region_rect.position = Vector2(-2.0 + 128.0 * nubType1, 288)
	
	$Top/Text.text = functionName
	$Bottom/Text.text = bottomText
	side.scale.y =0.17 * (count) + 0.075
		
	
func _ready():
	update()

	
func _process(delta: float) -> void:
	if unit != Global.selectedUnit && location == "editor":
		visible = false
		return
	if location == "editor":
		visible = true
	if holey:
		hole.region_rect.position = Vector2(-2.0 + 128 * holeType, 134.995)
		hole.region_rect.size = Vector2(134.0, 107.0)
	else:
		hole.region_rect.position = Vector2(296.0, 7.0)
		hole.region_rect.size = Vector2(133, 107)
		holeArea.scale = Vector2(0, 0)
	
	$NubArea2/Nub2.region_rect.position = Vector2(-2.0 + 128.0 * nubType2, 288)
	$NubArea3/Nub2.region_rect.position = Vector2(-2.0 + 128.0 * nubType1, 288)
	if unit != null && "delay" in unit:
		delay = unit.delay
	if delay != null:
		$Timer.wait_time = delay
	print(delay)
	task.call(self)
	await get_tree().process_frame 
	
	attached = $inside.attached
	$Top/Text.text = functionName
	$Bottom/Text.text = bottomText
	
	
	nubArea.monitorable = !inside.attached
	nubArea2.monitorable = !outside.attached
	count = $inside.count
	if abs(side.scale.y - (0.17 * (count) + 0.075)) > 0.01: 
		side.scale.y = lerp(side.scale.y, 0.17 * (count) + 0.075, delta * 3)
	else:
		side.scale.y = 0.17 * (count) + 0.075

	
	if "count" in get_parent():
		get_parent().count = count + 2.2 + $outside.count
	
	# shtuff
	sideArea.position.y = side.position.y + side.scale.y * side.region_rect.size.y / 2
	sideArea.shape.size.y = (side.position.y + sideArea.position.y) 
	bottom.position.y = side.position.y + side.region_rect.size.y * side.scale.y - 1.0
	bottomArea.position.y = bottom.position.y + 15.0
	bottomArea.position.x = 65.0
	nubArea2.position.y = bottom.position.y + bottom.region_rect.size.y * bottom.scale.y - 4.0
	$outside.position.y = nubArea2.position.y - 25
	
	if location == "inventory":
		if sqrt((self.position.x - pos.x)**2 + (self.position.y - pos.y)**2) < 0.1:
			self.position = pos
		else:
			self.position = lerp(self.position, pos, delta * 10)
	if holeArea.monitoring == false && holeArea.monitorable == true && pos != null:
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
		Global.currBlock = self
		var mouse_position_global = get_viewport().get_mouse_position()
		position = mouse_position_global + offset
	elif Input.is_action_just_released("click") && entered == true:
		if "type" in loopBlock and loopBlock.type == "loop" && areaName == "NubArea2" && holeType != loopBlock.nubType2:
			return
		elif "type" in loopBlock and loopBlock.type == "loop" && areaName != "NubArea2" && holeType != loopBlock.nubType1:
			return
		elif "nubType" in loopBlock and holeType != loopBlock.nubType:
			return
			
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
			self.reparent(get_parent().get_child(9))
			pos = Vector2(0, 55)
			pass
		elif "type" in get_parent() and get_parent().type == "loop":
			self.reparent(get_parent().get_child(8))
			pos = Vector2(19.0, 25.5)
			pass
		elif "type" in get_parent() and get_parent().type == "action":
			pos = Vector2(-6, 27)
			
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

func run_thing(obj):
		obj.test.call(obj)
		if obj.get_child(9).get_child_count() == 1:
			run_thing(obj.get_child(9).get_child(0))
			
func _on_timer_timeout() -> void:
	if $inside.get_child_count() == 1:
		run_thing($inside.get_child(0))

		
	pass # Replace with function body.
