extends Node2D

@onready var text = $Top/Text
@onready var top = $Top/Top
@onready var end = $Top/End
@onready var connector = $Top/Connector
@onready var side = $Side
@onready var bottom = $Bottom

@onready var topArea = $ClickArea/Top
@onready var sideArea = $ClickArea/Side
@onready var bottomArea = $ClickArea/Bottom

@onready var nubArea = $NubArea
var state = "off"
var offset

const horizScale = 1.1
var pressed = false

var attached = false
var count = 0; 

var location = "inventory"
var type = "loop"

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
		
func _ready():
	# Dynamic changing size of block based on text
	top.scale.x = (text.size.x * text.scale.x / top.region_rect.size.x) * horizScale
	var topPixelSize = top.region_rect.size.x * top.scale.x
	var connectorPixelSize = connector.region_rect.size.x 
	end.position.x = topPixelSize + connectorPixelSize
	
	# Area Scales
	topArea.shape.size.x = (connector.position.x + end.position.x + end.scale.x * end.region_rect.size.x * horizScale)
	
	# Change click boxes positions
	topArea.position.x = connector.position.x + topArea.shape.size.x / 2.0
	bottomArea.position.x = bottom.position.x + bottom.region_rect.size.x * bottom.scale.x / 2.0
	sideArea.position.x = connector.position.x + connector.region_rect.size.x * connector.scale.x / 2.0
	side.scale.y = 2.2 * (count) + .1
	

func _process(delta: float) -> void:
	nubArea.monitorable = !attached
	if abs(side.scale.y - ( 2.2 * (count + 1))) > 0.001: 
		side.scale.y = lerp(side.scale.y, 2.2 * (count) + .1, delta * 3)
	else:
		side.scale.y = 2.2 * (count) + .2
	
	sideArea.position.y = side.position.y + side.scale.y * side.region_rect.size.y / 2
	
	sideArea.shape.size.y = (side.position.y + sideArea.position.y) * 3
	bottom.position.y = side.scale.y * side.region_rect.size.y - side.position.y - bottom.region_rect.size.y * bottom.scale.y
	bottomArea.position.y = bottom.position.y - bottomArea.shape.size.y / 2
	if get_child_count() > 7:
		get_child(7).reparent(get_tree().root)
	
	# Dynamic Dragging
	if pressed && state == "on" && Global.cursorGrab == false:
		var mouse_position_global = get_viewport().get_mouse_position()
		offset = position - mouse_position_global
		state = "dragging"
		Global.cursorGrab = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && state == "dragging":
		var mouse_position_global = get_viewport().get_mouse_position()
		position = mouse_position_global + offset
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
