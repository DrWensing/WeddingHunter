extends Node2D

const SPEED = 30
var direction = 1
@onready var hp = 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_bar = $HealthBar
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_right = $RayCast_Right
@onready var ray_cast_left = $RayCast_Left

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
