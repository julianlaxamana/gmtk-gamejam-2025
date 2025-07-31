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
			spawn_bug(0, "basic")
			spawn_bug(5, "basic")
			spawn_bug(10, "basic")
		2: 
			print("wave 2 has started")
	
	#wave += 1
	



# Transporting Path2d script
const bug_generic = preload("res://Scenes/Bugs/bug_generic.tscn")

@onready var path = $Control/FieldViewport.path
	
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
	path.add_child(temp)


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
