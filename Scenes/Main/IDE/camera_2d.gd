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
	
	position.x = clamp(position.x, 0, 200)
	position.y = clamp(position.y, 100, 200)
		
