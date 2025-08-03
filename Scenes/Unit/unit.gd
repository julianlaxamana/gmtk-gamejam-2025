extends Node2D
@onready var unitScript = preload("res://scenes/Unit/unitScript.tscn")
var radius = 2;
var level = 1
var currentBlocks = 0
var maxBlocks = 8
var delay
var target: Vector2


func _draw():
	draw_circle(Vector2(0, 0), 10.0, Color(0, 0, 0, 0.2))
	if Global.selectedUnit == self:
		draw_circle(Vector2(0,0), 18.0 * radius, Color(255 / 255, 221 / 255.0, 140.0 / 255.0, 0.5))
		
func enable_target():
	if self == Global.selectedUnit:
		$Target.visible = true
	
func disable_target():
	$Target.visible = false
	
func get_target():
	return $Target

var b = 0
var c = 0

func _process(delta):
	maxBlocks = 6 + 2 * level
	$Target.visible =false
	currentBlocks = Global.unitScripts[self].blockCount
	
	if self == Global.selectedUnit:
		target = get_global_mouse_position()
		
	b = rad_to_deg((global_position - target).rotated(90).angle())
	c = b
	if (b > 90):
		b = -b + 180
	elif b < -90:
		b = -b - 180 
	b = b / 90.0
	
	if abs(c) > 90.0:
		$Unit/Label.text = ""
		$Unit/Label/ColorRect.visible = false
	else:
		$Unit/Label.text = "._."
		$Unit/Label/ColorRect.visible = true
		
	$Unit.scale.x = (-abs(b) + 1) * .5
	$Unit.skew = (-abs(b) + 1)  * deg_to_rad(3) + deg_to_rad(15)
	
	
	if Input.is_action_pressed("shift") && self == Global.selectedUnit:
		$Target.position = get_local_mouse_position()
	queue_redraw()
func _ready() -> void:
	var script = unitScript.instantiate()
	Global.unitScripts[self] = script
