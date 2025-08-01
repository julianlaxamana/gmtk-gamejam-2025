extends Node2D
@onready var unitScript = preload("res://scenes/Unit/unitScript.tscn")

func _ready() -> void:
	var script = unitScript.instantiate()
	Global.unitScripts[self] = script
