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

func show_smoke():
	$AnimatedSprite2D.show()
	$AnimatedSprite2D2.show()
	$AnimatedSprite2D3.show()
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D2.visible = false
	$AnimatedSprite2D3.visible = false
	
	
func hide_smoke():
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D2.visible = true
	$AnimatedSprite2D3.visible = true
	
func show_henrik_tabea():
	$henrik.show()
	$tabea.show()
	
func hide_henrik_tabea():
	$henrik.hide()
	$tabea.hide()
	
