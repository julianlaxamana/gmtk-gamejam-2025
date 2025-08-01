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
			spawn_bug(0, "meep")
			spawn_bug(1, "fob")
			spawn_bug(2, "borf")
			spawn_bug(2, "zonk")
		2: 
			print("wave 2 has started")
	
	#wave += 1
	



# Transporting Path2d script
const bug_generic = preload("res://Scenes/Bugs/bug_generic.tscn")

@onready var path = Global.path_node
	
func _input(event):
	if event.is_action_pressed("debug_a"):
		Engine.time_scale = 2
	if event.is_action_pressed("debug_d"):
		Engine.time_scale = 1
	if event.is_action_pressed("debug_add_bug"):
		start_wave()


#region helper functions

func spawn_bug(delay, type: String):
	get_tree().create_timer(delay).timeout.connect(create_bug.bind(type))

func create_bug(type: String):
	# things to apply for all bugs, like size
	var bug = bug_generic.instantiate()
	bug.type = type
	bug.scale = Vector2(.25, .25) 
	bug.sprite_resource = Global.BUG_SPRITE_DICTIONARY[type]
	
	connect_bug_signals(bug)
	match type:
		"meep":
			bug.health = 20
			bug.value = 8 
			bug.speed = 1.578 # good
			bug.damage = 20
		"fob":
			bug.health = 10
			bug.value = 5
			bug.speed = 3.5
			bug.damage = 10
		"borf":
			bug.health = 75
			bug.value = 25
			bug.speed = 1.276
			bug.damage = 50
		"spoid":
			pass
		"tiny_spoid":
			pass
		"bleep":
			pass
		"zonk":
			bug.health = 5
			bug.value = 40
			bug.speed = 4.32
			bug.damage = 30
		"lez_tail":
			pass
		"lez_middle":
			pass
		"lez_head":
			pass
		"smorg":
			pass
	
	# do for all bugs
	path.add_child(bug)


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
