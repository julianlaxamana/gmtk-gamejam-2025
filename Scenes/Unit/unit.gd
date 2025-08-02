extends Node2D
@onready var unitScript = preload("res://scenes/Unit/unitScript.tscn")
var radius = 2;


func _draw():
	if Global.selectedUnit == self:
		draw_circle(Vector2(0,0), 18.0 * radius, Color(255 / 255, 221 / 255.0, 140.0 / 255.0, 0.5))
func enable_target():
	if self == Global.selectedUnit:
		$Target.visible = true
	
func disable_target():
	$Target.visible = false
	
func get_target():
	return $Target

func _process(delta):
	$Target.visible =false
	if Input.is_action_pressed("debug_a"):
		$Target.position = get_local_mouse_position()
	queue_redraw()
	
func _ready() -> void:
	var script = unitScript.instantiate()
	Global.unitScripts[self] = script
