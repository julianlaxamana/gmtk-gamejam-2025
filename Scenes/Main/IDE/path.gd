extends Path2D



const bug_generic = preload("res://Scenes/Bugs/bug_generic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _input(event):
	if event.is_action_pressed("debug_a"):
		Engine.time_scale = 2
	if event.is_action_pressed("debug_d"):
		Engine.time_scale = 1
	if event.is_action_pressed("debug_add_bug"):
		start_wave(1)

func start_wave(wave: int):
	match wave:
		1:
			spawn_bug(0, "basic")
			spawn_bug(5, "basic")
			spawn_bug(10, "basic")


#region helper functions

func spawn_bug(delay, type: String):
	get_tree().create_timer(delay).timeout.connect(create_bug.bind(type))

func create_bug(type: String):
	var temp = bug_generic.instantiate()
	var string = "bug_" + type
	connect_bug_signals(temp)
	match type:
		"basic":
			temp.health = 20
			temp.value = 5
			temp.speed = 2
			temp.damage = 1
			temp.sprite_resource = Global.BUG_SPRITE_DICTIONARY[string]
			temp.scale = Vector2(.25, .25)
			pass
		"type2":
			pass
	
	# do for all bugs
	add_child(temp)


func connect_bug_signals(n):
	n.bug_reached_end.connect(_on_bug_reached_end)
	n.bug_died.connect(_on_bug_died)

#endregion

#region bug signal logic
func _on_bug_reached_end(damage: int):
	# hurt the thing
	# that's it
	pass
	
func _on_bug_died(value: int):
	# give gold to player
	pass

#endregion
