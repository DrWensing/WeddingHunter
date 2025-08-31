extends Node2D

const SPEED = 10
var direction = -1
@onready var hp = 500

					
const LAVA_SPAWN_POINTS =  {0: Vector2(1050,320), #possible spawn points of minions
							1: Vector2(1075,320),
							2: Vector2(1100,320),
							3: Vector2(1125,320),
							4: Vector2(1150,320),
							5: Vector2(1175,320),
							6: Vector2(1200,320),
							7: Vector2(1225,320),
							8: Vector2(1250,320),
							9: Vector2(1275,320),
							10: Vector2(1300,320),
							11: Vector2(1325,320),
							12: Vector2(1350,320),
							13: Vector2(1375,320),
							14: Vector2(1400,320)}

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

@export var lava_scene: PackedScene = preload("res://scenes/lava_floor.tscn")

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
	
	if $LavaTimer.time_left <= 0:
		summon_lava()
	
	#every 10s do random attack
	if $RandomAttackTimer.is_stopped():
		attack()
		$RandomAttackTimer.start(10.0)
	
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

func walk():
	is_attacking = false
	
func _on_timer_timeout():
	walk()

func summon_lava(position = randi_range(0, 14)):
	var rand_position = LAVA_SPAWN_POINTS[position] # random position: 1,2 bottom, 3,4 first platform (L/R) and so on
	print(rand_position)
	#summons a lava
	var lava = lava_scene.instantiate()
	
	# set entry position
	lava.global_position = Vector2(rand_position[0]+15,rand_position[1])

	#register fireball in its container
	%Enemies.add_child(lava)
	$LavaTimer.start(1)
