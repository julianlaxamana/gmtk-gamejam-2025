extends HSlider


var previous_value = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_value_changed(value):
	var delta = value - previous_value
	for node in get_tree().get_nodes_in_group("SFX"):
		node.volume_db += delta
