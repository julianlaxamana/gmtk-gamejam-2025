extends PathFollow2D

var type: String
var health: int # health of unit
var value: int  # money on death
var speed: int # speed in pixels
var damage: int  # how much damage to deal


# status effect variables
@onready var fire_timer = $FireTimer
@onready var fire_ticker = $FireTimer/FireTicker
var is_on_fire = false

var fire_damage = 3
var poison_damage = 2 

var fire_length = 5
var poison_length = 2.5

var poison_tick_frequency = .5# in seconds
var fire_tick_frequency = .2 # in seconds

var fire_speed_change = .253
var posion_speed_change = .047 

@onready var sprite = $Sprite # sprite 2d node

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
	fire_timer.timeout.connect(fire_clear)
	fire_ticker.timeout.connect(apply_fire_tick)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# determine velocity direction
	var previous_position = position
	
	# standard movement
	progress += speed * Global.timeScale * delta * 60.0
	
	# resume computation
	var new_position = position
	var velocity = new_position - previous_position
	var theta = atan2(velocity.y, velocity.x)
	
	if progress_ratio > .999:
		bug_reached_end.emit(damage)
		self.queue_free()
		
	if health <= 0:
		# cant write tini_spoid spawn logic here because each bug needs to be tied
		# to various signals in main
		bug_died.emit(value, type, position) 
		self.queue_free()
	
	if theta <= deg_to_rad(-167.5):
		sprite.texture = Global.BUG_SPRITE_DICTIONARY[type]["DL"]
	elif theta <= deg_to_rad(-40):
		sprite.texture = Global.BUG_SPRITE_DICTIONARY[type]["UL"]
	elif theta <= deg_to_rad(7.5):
		sprite.texture = Global.BUG_SPRITE_DICTIONARY[type]["UR"]
	elif theta <= deg_to_rad(105):
		sprite.texture = Global.BUG_SPRITE_DICTIONARY[type]["DR"]
	else:
		sprite.texture = Global.BUG_SPRITE_DICTIONARY[type]["DL"]



func apply_poison():
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.start(poison_tick_frequency / Global.timeScale)
	timer.timeout.connect(apply_poison_tick)
	get_tree().create_timer(poison_length / Global.timeScale).timeout.connect(poison_clear.bind(timer))
	apply_poison_tick()

func apply_poison_tick():
	health -= poison_damage

func poison_clear(timer_node):
	timer_node.queue_free()
	
func apply_fire():
	if not is_on_fire:
		fire_ticker.start()
		apply_fire_tick()
	is_on_fire = true
	fire_timer.start(fire_length / Global.timeScale)

func apply_fire_tick():
	if is_on_fire:
		damage -= fire_damage

func fire_clear():
	is_on_fire = false
	fire_timer.stop()
	fire_ticker.stop()
