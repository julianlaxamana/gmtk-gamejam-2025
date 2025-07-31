extends TileMapLayer

func _process(delta: float) -> void:
	position.y += delta * 25
	if position.y > 2178:
		position.y = 2000
