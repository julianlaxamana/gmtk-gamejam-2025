extends PathFollow2D

var type: String
var health: float # health of unit
var value: float  # money on death
var base_speed: float # speed in pixels
var speed
var damage: float  # how much damage to deal

@onready var hp_bar = $HP

# status effect variables
@onready var fire_timer = $FireTimer
@onready var fire_ticker = $FireTimer/FireTicker
@onready var poison_particles = $PoisonParticles
@onready var fire_particles = $FireParticles
@onready var flash_animator = $Sprite/FlashAnimation

@onready var slow_timer = $SlowTimer
@onready var stun_timer = $StunTimer

var is_slowed = false
var is_stunned = false

var is_on_fire = false

var fire_damage = 3
var poison_damage = 1.3

var fire_length = 5
var poison_length = 2.5

var poison_tick_frequency = .5# in seconds
var fire_tick_frequency = .2 # in seconds

var fire_speed_change = .353
var poison_count = 0


@onready var sprite = $Sprite # sprite 2d node

var pixel_offset_range = 20 # 10pixels left and right, up and down

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
	base_speed = speed
	h_offset += randf() * pixel_offset_range - pixel_offset_range/2.0
	v_offset += randf() * pixel_offset_range - pixel_offset_range/2.0
	fire_timer.timeout.connect(fire_clear)
	fire_ticker.timeout.connect(apply_fire_tick)
	
	stun_timer.timeout.connect(stun_clear)
	
	hp_bar.max_value = health
	global_skew = 0
	global_rotation = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update hp
	hp_bar.value = health
	
	
	
	
	if not is_stunned:
		# determine velocity direction
		var previous_position = position
		
		# standard movement
		progress += speed * Global.timeScale * delta * 60.0
		
		# resume computation
		var new_position = position
		var velocity = new_position - previous_position
		var theta = atan2(velocity.y, velocity.x)
		
		# change sprite
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
	
	if progress_ratio > .999:
		bug_reached_end.emit(damage)
		self.queue_free()
		
	if health <= 0:
		# cant write tini_spoid spawn logic here because each bug needs to be tied
		# to various signals in main
		bug_died.emit(value, type, position) 
		self.queue_free()



func apply_poison():
	poison_particles.emitting = true
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.start(poison_tick_frequency / Global.timeScale)
	timer.timeout.connect(apply_poison_tick)
	get_tree().create_timer(poison_length / Global.timeScale).timeout.connect(poison_clear.bind(timer))
	apply_poison_tick()
	

func apply_poison_tick():
	flash_animator.stop(true)
	sprite.material.set_shader_parameter("flash_color", Color(0, 232/255.0, 0))
	flash_animator.play("color_flash")
	health -= poison_damage

func poison_clear(timer_node):
	poison_particles.emitting = false
	timer_node.queue_free()

func apply_fire():
	fire_particles.emitting = true
	if not is_on_fire:
		speed += fire_speed_change
		fire_ticker.start()
		apply_fire_tick()
	is_on_fire = true
	fire_timer.start(fire_length / Global.timeScale)

func apply_fire_tick():
	if is_on_fire:
		flash_animator.stop(true)
		sprite.material.set_shader_parameter("flash_color", Color(1, 0, 0))
		flash_animator.play("color_flash")
		damage -= fire_damage
	

func fire_clear():
	speed -= fire_speed_change
	fire_particles.emitting = false
	is_on_fire = false
	fire_timer.stop()
	fire_ticker.stop()



func apply_slow(scaler):
	if not is_stunned:
		sprite.material.set_shader_parameter("mix_value", 50)
		sprite.material.set_shader_parameter("current_color", Color(0, 0, 1))

	if not is_slowed:
		speed -= base_speed * (1.0 - scaler)
		print(speed)
		slow_timer.timeout.connect(slow_clear.bind(scaler)) # pass to future one
	is_slowed = true
	slow_timer.start(5 / Global.timeScale)
	print("slow")

func slow_clear(scaler):
	sprite.material.set_shader_parameter("mix_value", 0)
	speed += base_speed * (1.0 - scaler)
	print(speed)
	is_slowed = false
	slow_timer.stop()
	print("slow done")
	
func apply_stun():
	sprite.material.set_shader_parameter("mix_value", 50)
	sprite.material.set_shader_parameter("current_color", Color(0, 1, 1))
	#sprite.material.shader_paramter
	is_stunned = true
	stun_timer.start(1 / Global.timeScale)

func stun_clear():
	if is_slowed:
		sprite.material.set_shader_parameter("current_color", Color(0, 0, 1))
	else:
		sprite.material.set_shader_parameter("mix_value", 0)
	is_stunned = false
	stun_timer.stop()
	print("stun stop")
