extends Node2D

var wave = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_wave():
	match wave:
		1:
			print("wave 1 has started")
		2: 
			print("wave 2 has started")
