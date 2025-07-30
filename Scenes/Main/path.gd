extends Path2D



const bug_generic = preload("res://Scenes/Bugs/bug_generic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _input(event):
	if event.is_action_pressed("debug_add_bug"):
		var temp = bug_generic.instantiate()
		temp.health = 0
		temp.value = 0
		temp.speed = 1
		temp.damage = 1
		temp.sprite_resource = 1
		add_child(temp)
	
		
		# the groups wil ALWAYS be ordered from closest to the end to the farthest
		var nodes = get_tree().get_nodes_in_group("bugs")
		for n in nodes:
			print(n.progress_ratio)

func create_bug(type: String):
	match type:
		"type1":
			#var temp = bug_generic.instantiate()
			#temp.health = 0
			#temp.value = 0
			#temp.speed = 1
			#temp.damage = 1
			#temp.sprite_resource = 1
			#add_child(temp)
			#add_child(temp)
			pass
		"type2":
			pass

func connect_bug_signals(n):
	n.bug_reached_end.connect(_on_bug_reached_end)
	n.bug_died.connect(_on_bug_died)
	
func _on_bug_reached_end(damage: int):
	# hurt the thing
	# that's it
	pass
	
func _on_bug_died(value: int):
	# give gold to player
	pass
