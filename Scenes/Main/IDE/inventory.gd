extends Node2D
var inventory = []
var index = 0

func _process(delta: float) -> void:
	for node in Global.inventory:
		inventory.append(node)
		node.reparent($Label2)
		node.position = Vector2($Label2.size.x / 2.0 - 64, $Label2.size.y / 2.0 + 15)
		node.pos = Vector2($Label2.size.x / 2.0 - 64, $Label2.size.y / 2.0 + 15)
		node.location = "inventory"
		Global.inventory.pop_front()
	
	if !inventory.is_empty():
		for node in inventory:
			if node.location == "editor":
				inventory.erase(node)
				if index > 0:
					index -= 1;
				return

			if node == inventory[index]:
				node.visible = true
			else:
				node.visible = false
	


func _on_button_button_down() -> void:
	index += 1
	print(inventory.size())
	if index >= inventory.size():
		index = 0
	pass # Replace with function body.


func _on_button_2_button_down() -> void:
	index -= 1
	if index < 0 :
		index = inventory.size() - 1
	pass # Replace with function body.
