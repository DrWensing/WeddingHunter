extends Node2D

const SPEED = 60
var direction = 1
@onready var hp = 200

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_bar = $HealthBar
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_right = $RayCast_Right
@onready var ray_cast_left = $RayCast_Left

@onready var velocity_y = 0

func _ready():
	health_bar.initialize(hp)

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = +1
		animated_sprite_2d.flip_h = false
	
	#move enemy from left to right (switching direction on collision)
	position.x +=  direction * SPEED * delta
	position.y += velocity_y * delta
	
func receive_damage(dmg):
	health_bar.take_dmg(dmg)
	if health_bar.is_dead():
		print('Enemy slain!')
		Main.add_point()
		queue_free()

func _on_area_2d_area_entered(area):
	print(area)
	#this is a bit of a hack, for some reason the different fireballs are not all of the fireball class
	if area.name == "Fireball" or area.name.begins_with("@Area2D"):
		receive_damage(area.dmg)
		area.free()

func _on_jump_timer_timeout():
	velocity_y = -150
	$JumpReturnTimer.start(0.2)

func _on_jump_return_timer_timeout():
	velocity_y = +150
	$JumpEndTimer.start(0.2)
	
func _on_jump_end_timer_timeout():
	velocity_y = 0
	$JumpTimer.start(3.0)
