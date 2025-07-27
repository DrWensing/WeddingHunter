extends Area2D

@onready var pickup_sound = $pickup_sound
@onready var sprite = $AnimatedSprite2D
@onready var coll_shape = $CollisionShape2D

@onready var ing_type = 'apple'

func _ready():
	set_type(ing_type)
	

	
func set_type(input):
	#convert string to frame ID 
	var frame = Main.ing_type_to_frame(input)
	#set frame from ID
	sprite.frame = frame

	#set property
	ing_type = input

func _on_body_entered(body):
	Main.receive_ingredient(ing_type)
	pickup_sound.play()
	coll_shape.disabled = true  # Prevent further collisions
	sprite.visible = false       # Optional: hide coin immediately
		
func _on_pickup_sound_finished():
	queue_free()
