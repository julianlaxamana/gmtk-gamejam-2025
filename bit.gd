extends TextureRect

@onready var timer = $Timer

var is_one = true

var one = preload("res://Assets/bit/BIT_1.webp")
var zero = preload("res://Assets/bit/BIT_0.webp")

# Called when the node enters the scene tree for the first time.

func inverse_pdf_sample():
	return log(randf_range(0, 2)) / -2.0 + 0.34657359028

func _ready():
	timer.start(inverse_pdf_sample())
	timer.timeout.connect(flip)
	
	pass # Replace with function body.

func flip():
	if is_one:
		texture = zero
		is_one = false
	else:
		texture = one
		is_one = true
	timer.start(inverse_pdf_sample())
