extends Area2D


@onready var pickup_sound = $pickup_sound

func _on_body_entered(body):
	Main.add_point()
	pickup_sound.play()
	queue_free()

