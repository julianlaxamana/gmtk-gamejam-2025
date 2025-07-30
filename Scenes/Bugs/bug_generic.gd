extends PathFollow2D

var health: int = 100
var value: int = 5 # money on death
var speed: int = 2 # speed in pixels
var damage: int = 10 # how much damage to deal
var sprite_resource = preload("res://Assets/Bugs/bug_basic.png") # to be sent on init


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
	progress += speed # move
	
	if progress_ratio > .999:
		self.queue_free()
		bug_reached_end.emit(damage)
		
	if health <= 0:
		bug_died.emit(value)
		self.queue_free()
