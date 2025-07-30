extends Node2D

@onready var text = $Top/Text
@onready var top = $Top/Top
@onready var end = $Top/End
@onready var connector = $Top/Connector

@onready var bottom = $Bottom

@onready var topArea = $ClickArea/Top
@onready var sideArea = $ClickArea/Side
@onready var bottomArea = $ClickArea/Bottom
var state = "off"
var offset

const horizScale = 1.1
var pressed = false

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
	print(connector.position)
	print(bottom.scale * bottom.region_rect.size)
	
	# Change click boxes positions
	topArea.position.x = connector.position.x + topArea.shape.size.x / 2.0
	bottomArea.position.x = bottom.position.x + bottom.region_rect.size.x * bottom.scale.x / 2.0
	sideArea.position.x = connector.position.x + connector.region_rect.size.x * connector.scale.x / 2.0
	

func _process(delta: float) -> void:
	
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
	else:
		Global.cursorGrab = false
	pressed = false;


func _on_click_area_mouse_entered() -> void:
	state = "on"
	pass # Replace with function body.

func _on_click_area_mouse_exited() -> void:
	state = "off"
	pass # Replace with function body.
