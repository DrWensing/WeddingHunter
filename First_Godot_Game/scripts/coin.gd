extends Area2D

@onready var game_manager = %GameManager
@onready var pickup_sound = $pickup_sound

func _on_body_entered(body):
	game_manager.add_point()
	pickup_sound.play()
	queue_free()

