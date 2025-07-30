extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func fire():
	print("pew" + self.name)
	
	# move the call down
	var temp = get_child(0)
	
	if temp != null:
		temp.fire()
	
