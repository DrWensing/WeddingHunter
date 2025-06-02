extends Node2D

const SPEED = 20
var direction = -1
@onready var hp = 300

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_bar = $HealthBar
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_right = $RayCast_Right
@onready var ray_cast_left = $RayCast_Left
@onready var KillZone = $KillZone
@onready var attack_timer = $Timer
@onready var active = false

@onready var is_attacking = false

func _ready():
	health_bar.initialize(hp)

func _physics_process(delta):
	#move enemy from left to right (switching direction on collision)
	if active == false:
		return
		
	if !is_attacking:
		position.x +=  direction * SPEED * delta
	
	if is_attacking:
		animated_sprite_2d.play("attack2")
	else:
		animated_sprite_2d.play("walk2")
	
func receive_damage(dmg):
	health_bar.take_dmg(dmg)
	if health_bar.is_dead():
		print('Enemy slain!')
		Main.add_point()
		queue_free()

func _on_area_2d_area_entered(area):
	#this is a bit of a hack, for some reason the different fireballs are not all of the fireball class
	if area.name == "Fireball" or area.name.begins_with("@Area2D"):
		receive_damage(area.dmg)
		area.free()
		
func attack():
	is_attacking = true
	attack_timer.start()
	print('Balrog attack')

func walk():
	is_attacking = false
	
func _on_timer_timeout():
	walk()
