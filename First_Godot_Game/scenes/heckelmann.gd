extends Node2D

const SPEED = 60
var direction = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player = %Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
		
	if player.position.x > position.x + 30:
		direction = +1
		animated_sprite_2d.flip_h = true
	elif player.position.x < position.y - 30:
		direction = -1
		animated_sprite_2d.flip_h = false
	else:
		direction = 0
	
	#move enemy from left to right (switching direction on collision)
	position.x +=  direction * SPEED * delta
	
	
