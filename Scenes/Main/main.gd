extends Node2D

var wave = 1
var bits = 0
var base_health = 100
var wave_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var wave_list = [
	1, # 1
	2, # 2
	3, # 3
	4, # 4
	5, #5
	6, #6
	7, #7
	8, #8
	9, #9
	10, #10
	11, #11
	12, #12
	13, #13
	14, #14
	15, #15
	16, #16
	17, #17
	18, #18
	19, #19
	20, #20
	21, #21
	22, #22
	23, #23
	24, #24
	25, #25
	26, #26
	27, #27
	28, #28
	29, #29
	30, #30
	31, #31
	32, #32
	33, #33
	34, #34
	35, #35
	36, #36
	37, #37
	38, #38
	39, #39
	40, #40
]

#region wavelist
func start_wave():
	# this works by wave is going from 1 onwards
	# wave_list returns a string based on index
	# to insert a wave, instead just insert a new string
	# to make switching around waves easier than manually changing
	# all the integers past a certain point up a number
	
	var wave = 4
	
	match wave_list[wave - 1]:
		1: # 20 basic
			print(wave, " has started")
			spawn_many_bugs(0, 1.25, 20, "meep")
		2: # 20 basic 30 swarm
			print(wave, " has started")
			spawn_many_bugs(0, 1.25, 20, "meep")
			spawn_many_bugs(10, 1.5, 30, "fob")
		3:
			print(wave, " has started")
			spawn_many_bugs(.7, 1, 30, "meep")
			spawn_bugs_in_timeframe(0, 30, 10, "borf")
		4:
			print(wave, " has started")
			spawn_many_bugs(0, 1, 30, "meep")
			spawn_many_bugs(0, 1.25, 40, "fob")
			spawn_bugs_in_timeframe(0, 40 * 1.3, 10, "borf")
			
		5:
			print(wave, " has started")
			for i in range(10):
				spawn_bugs_in_timeframe(i, 10, 20, "meep")
		6:
			print(wave, " has started")
			var i = 0
			while i < .47 * 10:
				spawn_bugs_in_timeframe(i, 5, 20, "fob")
				i += .47
		7:
			pass
		8:
			pass
		9:
			pass
		10:
			pass
		11:
			pass
		12:
			pass
		13:
			pass
		14:
			pass
		15:
			pass
		16:
			pass
		17:
			pass
		18:
			pass
		19:
			pass
		20:
			pass
		21:
			pass
		22:
			pass
		23:
			pass
		24:
			pass
		25:
			pass
		26:
			pass
		27:
			pass
		28:
			pass
		29:
			pass
		30:
			pass
		31:
			pass
		32:
			pass
		33:
			pass
		34:
			pass
		35:
			pass
		36:
			pass
		37:
			pass
		38:
			pass
		39:
			pass
		40:
			pass
	wave += 1

#endregion wave list

func lost_game():
	#TODO reset board and all units
	# queue_free it all
	pass

# Transporting Path2d script
const bug_generic = preload("res://Scenes/Bugs/bug_generic.tscn")


var bug
@onready var path = Global.path_node
func _input(event):
	if event.is_action_pressed("debug_add_bug"):
		start_wave()
	if event.is_action_pressed("debug_a"):
		print("a pressed")
		bug = create_bug("fob")
	if event.is_action_pressed("debug_d"):
		print("d pressed")
		bug.apply_poison()
	if event.is_action_pressed("debug_s"):
		print("s pressed")
		bug.apply_fire()
	if event.is_action_pressed("debug_w"):
		print("w pressed")
		bug.apply_stun()
	if event.is_action_pressed("q"):
		Global.computer_terminal_style_box.bg_color = Color(1, 0, 0)
		#Global.computer_terminal.add_theme_stylebox_override("normal", new_stylebox_normal)
		print("q pressed")
		#bug.apply_slow(.3)


#region bug signal logic
func _on_bug_reached_end(damage: int):
	# hurt the thing
	base_health -= damage
	Global.computer_terminal_style_box.bg_color = Color((-2.04 * base_health + 255) / 255, (.51 * base_health)/255, (.51 * base_health)/255)
	
	if base_health <= 0:
		lost_game()
	
func _on_bug_died(value: int, type: String, death_position):
	# give gold to player
	bits += value
	
	if type == "spoid":
		for i in range(3):
			var bug = bug_generic.instantiate()
			bug.type = "tini_spoid"
			bug.position = position
			# stats
			bug.health = 40
			bug.value = 1
			bug.speed = 3.578
			bug.damage = 4
			path.add_child(bug)
			path.add_child(bug)

#endregion


#region helper functions
# will produce equally spaced outbugs given a count and seconds inbetween each
# initial_delay how long to wait before the chain starts spawning
# how many seconds to wait inbetween each one
# how many to spawn
func spawn_many_bugs(initial_delay, step, count, type: String):
	var i = 0
	while i < step * count:
		spawn_bug(i + initial_delay, type)
		i += step

# will produce equall spaced out bugs given duration and count
# initial delay how long to wait before starting to spawn the chain
# how long it should go on for
# how many to spawn
func spawn_bugs_in_timeframe(initial_delay, duration, count, type: String):
	var i = 0
	var step = duration / float(count)
	while i < step * count:
		spawn_bug(i + initial_delay, type)
		i += step

func spawn_bug(delay, type: String):
	get_tree().create_timer(delay / Global.timeScale).timeout.connect(create_bug.bind(type))

func create_bug(type: String):
	# things to apply for all bugs, like size
	var bug = bug_generic.instantiate()
	bug.type = type
	connect_bug_signals(bug)
	match type:
		"meep":
			bug.health = 50
			bug.value = 2
			bug.speed = 1.578 # good
			bug.damage = 3
		"fob":
			bug.health = 30
			bug.value = 1
			bug.speed = 3.5
			bug.damage = 1
		"borf":
			bug.health = 200
			bug.value = 5
			bug.speed = 1
			bug.damage = 10
		"spoid":
			bug.health = 80
			bug.value = 2
			bug.speed = 1.276
			bug.damage = 4
			pass
		"bleep":
			bug.health = 65
			bug.value = 8
			bug.speed = 2.11
			bug.damage = 4
			pass
		"zonk":
			bug.health = 25
			bug.value = 10
			bug.speed = 5.8
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
	return bug


func connect_bug_signals(n):
	n.bug_reached_end.connect(_on_bug_reached_end)
	n.bug_died.connect(_on_bug_died)

#endregion
