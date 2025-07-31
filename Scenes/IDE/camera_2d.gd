extends Camera2D

var previous_coordinates
var is_dragging
const pa = 1.11 # Area proportionality constant
const zoom_min: float = pow(1.11, -22/2.0) #roughly .3
const zoom_max: float = pow(1.11, 21/2.0) #roughly 2.9915
const dx = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	# referenced
	# https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html#mouse-motion
	if event.is_action("pan"):
		# record starting coordinates and start dragging
		if not is_dragging and event.pressed:
			is_dragging = true
			previous_coordinates = event.position
		# Stop dragging if the button is released.
		if is_dragging and not event.pressed:
			is_dragging = false

	# panning
	if event is InputEventMouseMotion and is_dragging:
		# While dragging, move the camera with the mouse
		# drag it in the direction opposite of the way the mouse moved
		# Also scale it by the reciprocal of how much we're zoomed in (if zoomed in further, reduce the amount of movement)
		position += (event.position - previous_coordinates) * -1 * (1 / zoom.x)
		
		#update the new previous coordinates
		previous_coordinates = event.position
		
	if event.is_action_pressed("zoom_in"):
		# vector from the cursor to the center of the camera
		var d = position - get_global_mouse_position() 
		var zoom2 = 1
		
		# zoom by constant screen width growth
		# zoom2 = (zoom * get_viewport().size.x)/(get_viewport().size.x * Vector2(1, 1) - zoom * dx)
		
		# new zoom amount
		zoom2 = (zoom.x * sqrt(pa)) * Vector2(1, 1)
		
		# clamp value
		zoom2 = zoom2.clamp(Vector2(1, 1) * zoom_min, Vector2(1, 1) * zoom_max)
		
		# using the formula i derived
		position = get_global_mouse_position() + d * (zoom / zoom2)
		zoom = zoom2
	if event.is_action_pressed("zoom_out"):
		# vector from the cursor to the center of the camera
		var d = position - get_global_mouse_position() 
		var zoom2 = 1
		
		# zoom2 = (zoom * get_viewport().size.x)/(get_viewport().size.x * Vector2(1, 1) + zoom * dx)
			
		# take the reciprocal instead
		zoom2 = (zoom.x / sqrt(pa)) * Vector2(1, 1)
		zoom2 = zoom2.clamp(Vector2(1, 1) * zoom_min, Vector2(1, 1) * zoom_max)
		position = get_global_mouse_position() + d * (zoom / zoom2)
		zoom = zoom2
		
