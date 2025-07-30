extends Node2D

var state = "off"
var offset

var pressed = false
var entered = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
		
func _ready():
	print("read")

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
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && entered == true:
		print("hi")
	else:
		Global.cursorGrab = false
		
	pressed = false;


func _on_click_area_mouse_entered() -> void:
	state = "on"
	pass # Replace with function body.

func _on_click_area_mouse_exited() -> void:
	state = "off"
	pass # Replace with function body.

func _on_click_area_area_entered(area: Area2D) -> void:
	entered = true
	pass # Replace with function body.


func _on_click_area_area_exited(area: Area2D) -> void:
	entered = false
	pass # Replace with function body.
