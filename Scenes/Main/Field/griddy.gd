extends TileMapLayer
var prevPos;

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
		
	var pos = local_to_map(get_local_mouse_position())
	if pos.x <= -23 && pos.x >= -47 && pos.y <= 16 && pos.y >= -8:
		
		for i in range(-47, -23):
			for j in range(-8, 16):
				set_cell(Vector2(i, j), 1, tileMap.get_cell_atlas_coords(Vector2(i, j)))
		
		if tileMap.get_cell_atlas_coords(pos).x > 3:
			set_cell(local_to_map(get_local_mouse_position()), 1, Vector2i(1, 0))
		
		print(tileMap.get_cell_atlas_coords(pos).x)
		if Input.is_action_just_pressed("click") && tileMap.get_cell_atlas_coords(pos).x > 3:
			if tileSet.has(map_to_local(local_to_map(get_local_mouse_position()))):
				Global.selectedUnit = tileSet[map_to_local(local_to_map(get_local_mouse_position()))]
			else:
				var newUnit = unit.instantiate()
				newUnit.position = map_to_local(local_to_map(get_local_mouse_position()))
				newUnit.z_index = -(sqrt(pos.x * pos.x + pos.y * pos.y)) + 100
				add_child(newUnit)
				tileSet[newUnit.position] = newUnit
				Global.selectedUnit = newUnit
			
		prevPos = pos
