extends Node2D

var wave = 1
var bits = 0
var base_health = 100
var wave_started = false
var looped_once = false # 40+'ed

@onready var wave_text = $Control/ShopBar/Label2/Label3
@onready var time_scale_slider = $Control/EditorBar/HSlider
@onready var next_wave_button = $Control/EditorBar/Button3
@onready var winner_text = $Control/Winner
@onready var music_player = $AudioStreamPlayer
@onready var hit_sfx = $HitSfx

var game_over_song = preload("res://Assets/Sounds/again (1).wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.hit_sfx = hit_sfx
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#region wavelist
func start_wave():
	wave_started = true
	time_scale_slider.editable = false
	# this works by wave is going from 1 onwards
	# wave_list returns a string based on index
	# to insert a wave, instead just insert a new string
	# to make switching around waves easier than manually changing
	# all the integers past a certain point up a number
	
	wave_text.text = str(wave)
	
	match wave:
		1: 
			if looped_once:
				winner_text.visible = false
			print(wave, " has started")
			# 10 basic
			spawn_many_bugs(0, 2.0, 10, "meep")
		2: 
			print(wave, " has started")
			# 20 basic 30 swarm
			spawn_many_bugs(0, 1.5, 15, "meep")
			spawn_many_bugs(10, 1.5, 1, "borf")
		3:
			print(wave, " has started")
			# 30 basic 10 strong
			spawn_many_bugs(.7, 1, 10, "meep")
			spawn_bugs_in_timeframe(0, 10, 5, "borf")
		4:
			print(wave, " has started")
			# 30 basic 40 swarm 10 strong
			spawn_many_bugs(0, 1.5, 10, "meep")
			spawn_many_bugs(17, 1, 5, "borf")
			spawn_many_bugs(23, 1.5, 10, "meep")
		5:
			print(wave, " has started")
			spawn_many_bugs(0, 0.2, 15, "fob")
			spawn_many_bugs(5, 1.5, 10, "meep")
		6:
			print(wave, " has started")
			spawn_many_bugs(0, 1.5, 3, "borf")
			spawn_many_bugs(7, 0.5, 10, "meep")
			spawn_many_bugs(15, 0.1, 15, "fob")
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
			
			
			if looped_once:
				wave = 0
				# add scaling here too
		41:
				wave = 0
				looped_once = true
				wave_text.text = str(wave)
				winner_text.visible = true
			# we could easily scale such stats here by looping through the dictionary and upping them
	wave += 1

#endregion wave list



func lost_game():
	Global.computer_terminal.reset()
	base_health = 100
	Global.computer_terminal_style_box.bg_color = Color((-2.04 * base_health + 255) / 255, (.51 * base_health)/255, (.51 * base_health)/255)
	
	#TODO reset board and all units
	# queue_free it all
	pass

# Transporting Path2d script
const bug_generic = preload("res://Scenes/Bugs/bug_generic.tscn")


var bug
@onready var path = Global.path_node
func _input(event):
	if event.is_action_pressed("alt"):
		start_wave()


#region bug signal logic
func _on_bug_reached_end(damage: int):
	# hurt the thing
	base_health -= damage
	Global.computer_terminal_style_box.bg_color = Color((-2.04 * base_health + 255) / 255, (.51 * base_health)/255, (.51 * base_health)/255)
	Global.computer_terminal.update(base_health)
	
	if base_health <= 0:
		lost_game()
		wave_started = false
		print("lost game")
		time_scale_slider.editable = true
		
	if len(get_tree().get_nodes_in_group("bugs")) == 0:
		wave_started = false
		
		print("bugs 0 via bug reached end")
		next_wave_button.visible = true
		time_scale_slider.editable = true
	
func _on_bug_died(value: int, type: String, death_position):
	# give gold to player
	bits += value
	
	if type == "spoid":
		for i in range(3):
			var bug = bug_generic.instantiate()
			bug.type = "tini_spoid"
			bug.position = position
			# stats
			bug.health = Global.BUG_STAT_DICTIONARY["tini_spoid"]["health"]
			bug.value = Global.BUG_STAT_DICTIONARY["tini_spoid"]["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY["tini_spoid"]["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY["tini_spoid"]["damage"]
			path.add_child(bug)
			path.add_child(bug)
	
	if len(get_tree().get_nodes_in_group("bugs")) == 0:
		print("bugs 0 via bug death")
		wave_started = false
		next_wave_button.visible = true
		time_scale_slider.editable = true

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

func create_custom_bug(health, value, speed, damage):
	var bug = bug_generic.instantiate()
	bug.type = "meep"
	
	bug.health = health
	bug.value = value
	bug.speed = speed
	bug.damage = damage
	connect_bug_signals(bug)
	path.add_child(bug)
	return bug
	

func create_bug(type: String):
	# things to apply for all bugs, like size
	var bug = bug_generic.instantiate()
	bug.type = type
	connect_bug_signals(bug)
	match type:
		"meep":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"fob":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"borf":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"spoid":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"bleep":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"zonk":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"lezzz_tail":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"lezzz_middle":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"lezzz_head":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
		"smorg":
			bug.health = Global.BUG_STAT_DICTIONARY['meep']["health"]
			bug.value = Global.BUG_STAT_DICTIONARY['meep']["value"]
			bug.speed = Global.BUG_STAT_DICTIONARY['meep']["speed"]
			bug.damage = Global.BUG_STAT_DICTIONARY['meep']["damage"]
	# do for all bugs
	path.add_child(bug)
	return bug
	
# specialized spawner for this entity
func spawn_lezzz(delay, step, middle_count):
	#var step = .20
	#var middle_count = 100
	spawn_bug(delay, "lezzz_head")
	spawn_many_bugs(delay + step, step, middle_count, "lezzz_middle")
	spawn_bug(delay + step * middle_count + step, "lezzz_tail")


func connect_bug_signals(n):
	n.bug_reached_end.connect(_on_bug_reached_end)
	n.bug_died.connect(_on_bug_died)

#endregion


func _on_button_3_button_down() -> void:
	start_wave()
	if not looped_once:
		next_wave_button.visible = false
