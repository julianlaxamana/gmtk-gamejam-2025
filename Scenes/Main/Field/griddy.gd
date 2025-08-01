extends TileMapLayer
var prevPos;

@onready var unit = preload("res://scenes/Unit/unit.tscn")
@onready var tileMap = $TileMapLayer
var tileSet := {
}
func _physics_process(delta):
	if Global.disableMouse:
		return
		
	var pos = local_to_map(get_local_mouse_position())
	if pos.x <= -23 && pos.x >= -47 && pos.y <= 16 && pos.y >= -8:
		set_cell(local_to_map(get_local_mouse_position()), 1, Vector2i(1, 0))
		
		if prevPos != pos && prevPos != null && tileMap != null:
			set_cell(prevPos, 1, tileMap.get_cell_atlas_coords(prevPos))
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if tileSet.has(map_to_local(local_to_map(get_local_mouse_position()))):
				Global.selectedUnit = tileSet[map_to_local(local_to_map(get_local_mouse_position()))]
				print(Global.selectedUnit)
			else:
				var newUnit = unit.instantiate()
				newUnit.position = map_to_local(local_to_map(get_local_mouse_position()))
				newUnit.z_index = -(sqrt(pos.x * pos.x + pos.y * pos.y)) + 100
				add_child(newUnit)
				tileSet[newUnit.position] = newUnit
				Global.selectedUnit = newUnit
				print(Global.selectedUnit)
			
		prevPos = pos
