extends Node2D

var count = 0
var attached = false

func _process(delta: float) -> void:
	print(count)

func get_count():
	return count
