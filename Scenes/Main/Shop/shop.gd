extends Node2D
@onready var box = preload("ShopBox.tscn")
@onready var boxes = $Boxes
var NUM_ITEMS = 3
func _ready() -> void:
	reroll()

func reroll():
	for child in boxes.get_children():
		boxes.remove_child(child)
		
	for i in range(NUM_ITEMS):
		var itemBox = box.instantiate()
		itemBox.position = Vector2(0, (i - 1) * 107.0)
		boxes.add_child(itemBox)


func _on_reroll_button_down() -> void:
	reroll()
	pass # Replace with function body.
