extends TextureRect

@onready var timer = $Timer

var is_one = true

var one = preload("res://Assets/bit/BIT_1.webp")
var zero = preload("res://Assets/bit/BIT_0.webp")

# Called when the node enters the scene tree for the first time.

func inverse_pdf_sample():
	return log(0.0676676416183 * randf_range(0, 14.777)) / -2.0

func _ready():
	timer.start(inverse_pdf_sample())
	timer.timeout.connect(flip)
	print("time start")
	
	pass # Replace with function body.

func flip():
	print("timeout")
	if is_one:
		texture = zero
		is_one = false
	else:
		texture = one
		is_one = true
	timer.start(inverse_pdf_sample())
