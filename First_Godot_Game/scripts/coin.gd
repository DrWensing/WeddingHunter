extends Area2D

@onready var pickup_sound = $pickup_sound
@onready var sprite = $AnimatedSprite2D
@onready var coll_shape = $CollisionShape2D

func _on_body_entered(body):
	Main.add_point()
	pickup_sound.play()
	coll_shape.disabled = true  # Prevent further collisions
	sprite.visible = false      # Optional: hide coin immediately
	collision_layer = 5
	collision_mask = 5
		
func _on_pickup_sound_finished():
	queue_free()
