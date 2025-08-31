extends Node2D

const xSPEED = 50
const ySPEED = 100
var xdirection = 1
var ydirection = 1

func _process(delta):
	self.position.x -= delta * xSPEED * xdirection
	self.position.y += delta * ySPEED * ydirection

	if xdirection == 1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

func _on_timer_timeout():
	xdirection *= -1

func _on_up_down_timer_timeout():
	ydirection *= -1
