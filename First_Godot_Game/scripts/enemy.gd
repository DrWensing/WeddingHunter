extends Node2D

const SPEED = 60
var direction = 1

@onready var health_bar = $HealthBar
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_right = $RayCast_Right
@onready var ray_cast_left = $RayCast_Left

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = +1
		animated_sprite_2d.flip_h = false
	
	#move enemy from left to right (switching direction on collision)
	position.x +=  direction * SPEED * delta


func receive_damage(dmg):
	health_bar.value -= dmg
	if health_bar.value <= 0:
		queue_free()

func _on_health_bar_ready():
	health_bar.value = 100
	
