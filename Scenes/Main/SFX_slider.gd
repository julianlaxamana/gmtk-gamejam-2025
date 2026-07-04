extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_value_changed(value):
	for node in get_tree().get_nodes_in_group("bugs"):
		node.get_child(node.get_child_count() - 1).volume_db = value
