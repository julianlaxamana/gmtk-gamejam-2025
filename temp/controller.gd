extends Timer

@onready var blocks = get_children()
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(_on_timeout)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("debug_add_bug"):
		print(get_time_left())
	if event.is_action_pressed("debug_a"):
		start()
		print("started")
	if event.is_action_pressed("debug_s"):
		stop()
		print("stop")
	if event.is_action_pressed("debug_w"):
		paused = true
		print("pause")
	if event.is_action_pressed("debug_d"):
		paused = false
		print("unpause")
		

# timer starts stopped
# start() stop() starts and stops
# pasued = t/f will preserve get_time_left()
func _on_timeout():
	get_child(0).fire()
