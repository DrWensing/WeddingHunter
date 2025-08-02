extends Node2D

var broken = true
var SPEED = 0

func repair():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D2.stop()
	$AnimatedSprite2D3.stop()
	broken = false
	
	$henrik.show()
	$tabea.show()

func _ready():
	$henrik.hide()
	$tabea.hide()

func _physics_process(delta):
	if not broken:
		self.position.x += SPEED*delta
