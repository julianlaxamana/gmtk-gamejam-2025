extends Label

@onready var fire_particles = $FireParticles

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.computer_terminal = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# gets passed new health to update
func update(health):
	
	if health <= 25:
		fire_particles.emitting = 6
		print("25")
	elif health <= 50:
		fire_particles.amount = 4
		fire_particles.gravity = Vector2(0, -500)
		print("50")
	elif health <= 75:
		fire_particles.emitting = true
		
		

func reset():
	fire_particles.emitting = false
	fire_particles.amount = 2
	fire_particles.lifetime = .36
	fire_particles.gravity = Vector2(0, -100)
