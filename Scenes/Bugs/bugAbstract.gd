class_name Bug extends PathFollow2D


const speed: int = 3 # speed in pixels
const damage: int = 10 # how much damage to deal
var sprite_resource = preload("res://Assets/Bugs/bugBasic.png") # to be sent on init


@onready var sprite = get_child(0) # sprite 2d node

# activates when a bug reaches the end of the track
# despawns itself
# @emits an int, how much damage the bug does
signal bug_reached_end

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = sprite_resource
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += speed # move
	
	if progress_ratio > .99:
		self.queue_free()
		bug_reached_end.emit(damage)
