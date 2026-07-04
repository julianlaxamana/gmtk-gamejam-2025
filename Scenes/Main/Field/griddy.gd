extends TileMapLayer
var prevPos;
var pos

@onready var unit = preload("res://scenes/Unit/unit.tscn")
@onready var tileMap = $TileMapLayer
var tileSet := {
}
func _ready() -> void:
	Global.grid = self
	pass
func _physics_process(delta):
	if Global.disableMouse:
		return
		
	pos = local_to_map(get_local_mouse_position())
	if pos.x <= -23 && pos.x >= -47 && pos.y <= 16 && pos.y >= -8:
		
		for i in range(-47, -22):
			for j in range(-9, 17):
				set_cell(Vector2(i, j), 1, tileMap.get_cell_atlas_coords(Vector2(i, j)))
		
		if tileMap.get_cell_atlas_coords(pos).x > 3:
			set_cell(local_to_map(get_local_mouse_position()), 1, Vector2i(1, 0))
		if Global.selectedBlock != null:
			set_cell(Global.selectedBlock, 1, Vector2i(1, 0))

		if Input.is_action_just_pressed("click") && tileMap.get_cell_atlas_coords(pos).x > 3:
			Global.selectedBlock = pos
			if tileSet.has(map_to_local(local_to_map(get_local_mouse_position()))):
				Global.selectedUnit = tileSet[map_to_local(local_to_map(get_local_mouse_position()))]
			else:
				Global.selectedUnit = null
		prevPos = pos

func placeUnit():
	if !tileSet.has(map_to_local(Global.selectedBlock)):
		var newUnit = unit.instantiate()
		newUnit.position = map_to_local(Global.selectedBlock)
		newUnit.z_index = -(sqrt(pos.x * pos.x + pos.y * pos.y)) + 100
		add_child(newUnit)
		tileSet[newUnit.position] = newUnit
		Global.selectedUnit = newUnit
