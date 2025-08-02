extends PathFollow2D

var type: String
var health: int # health of unit
var value: int  # money on death
var speed: int # speed in pixels
var damage: int  # how much damage to deal
var sprite_resource # to be sent on init


@onready var sprite = get_child(0) # sprite 2d node

# activates when a bug reaches the end of the track
# despawns itself
# @emits an int, how much damage the bug does
signal bug_reached_end

# activates when a bug is dead
# despawns itself
# @emits an int, how much the bug was worth
signal bug_died

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = sprite_resource # replace texture
	#TODO replace with sprite sheet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# determine velocity direction
	var previous_position = position
	
	# standard movement
	progress += speed * Engine.time_scale * delta * 60.0 * 4
	
	# resume computation
	var new_position = position
	var velocity = new_position - previous_position
	var theta = atan2(velocity.y, velocity.x)
	
	if progress_ratio > .999:
		bug_reached_end.emit(damage)
		self.queue_free()
		
	if health <= 0:
		bug_died.emit(value)
		self.queue_free()
	
	if theta <= deg_to_rad(-167.5):
		print("downleft")
	elif theta <= deg_to_rad(-40):
		print("upleft")
	elif theta <= deg_to_rad(7.5):
		print("upright")
	elif theta <= deg_to_rad(105):
		print("downright")
	else:
		print("downleft")
	
