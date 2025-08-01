extends Node2D
@onready var unitScript = preload("res://scenes/Unit/unitScript.tscn")
var radius = 2;


func _draw():
	if Global.selectedUnit == self:
		draw_circle(Vector2(0,0), 18.0 * radius, Color(255 / 255, 221 / 255.0, 140.0 / 255.0, 0.5))
	

func _process(delta):
	queue_redraw()
func _ready() -> void:
	var script = unitScript.instantiate()
	Global.unitScripts[self] = script
