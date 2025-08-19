extends Node2D

const SPEED = 50
var direction = 1

func _process(delta):
	self.position.x -= delta * SPEED * direction

	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

func _on_timer_timeout():
	direction *= -1
