extends Path2D



const bug_dictionary: Dictionary = {
	"bug_basic": preload("res://Scenes/Bugs/bug_generic.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _input(event):
	if event.is_action_pressed("debug_add_bug"):
		var temp = bug_dictionary["bug_basic"].instantiate()
		add_child(temp)
		pass
		
		# the groups wil ALWAYS be ordered from closest to the end to the farthest
		var nodes = get_tree().get_nodes_in_group("bugs")
		for n in nodes:
			print(n.progress_ratio)
