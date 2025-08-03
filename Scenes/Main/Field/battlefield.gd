extends Node2D
@onready var grid = $TileMapLayer
func _ready() -> void:
	Global.battlefield = self
