extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var hp = 100
var ammo = 5
var gun_equipped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var character = $Character
@onready var gun = $Gun
@onready var hp_bar_tabea = %HUD/HP_bar_tabea
@onready var ammo_bar_tabea = %HUD/ammo_tabea
@onready var fire_effect = $FireEffect
@onready var timer = $ShotTimer
@onready var gunshot = $gunshot
@onready var reload = $reload
@onready var game_manager = %GameManager
@onready var projectile_spawn_point:Marker2D = %ProjectileSpawnPoint
@onready var projectile_container = %projectile_container

@export var projectileprefab:PackedScene

func take_damage(dmg):
	hp -= dmg
	hp_bar_tabea.value = hp
	print('Tabea HP remaining ' + str(hp))
	
	if hp <= 0:
		print('Tabea died!')

func equip_gun():
	gun.visible=true
	gun_equipped = true
	fire_effect.visible=false
	
func unequip_gun():
	gun.visible = false
	gun_equipped = false
	fire_effect.visible=false

func shoot():
	if gun_equipped:
		if ammo > 0:
			if timer.is_stopped():
				ammo -= 1
				ammo_bar_tabea.frame = ammo
				print('Tabea: Pew pew!')
				timer.start(0.7)
				fire_effect.visible=true
				gunshot.play()
			else:
				print('not ready yet')
		else:
			print('Out of ammo: reloading')
			reload.play()
			ammo = 5
			ammo_bar_tabea.frame = ammo
			timer.start(3)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	#take_damage(delta/10)
	
	# Handle shoot rifle
	if Input.is_action_just_pressed("shoot_P2"):
		shoot()

	# Handle jump.
	if Input.is_action_just_pressed("jump_P2") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left_P2", "move_right_P2")
	if direction:
		velocity.x = direction * SPEED

		#Flip the sprites
		if direction == -1:
			character.flip_h = true
			gun.flip_h = true
			gun.position.x = character.position.x -10
			fire_effect.flip_h = true			
			fire_effect.position.x = character.position.x -35
		else:
			character.flip_h = false
			gun.flip_h = false
			gun.position.x = character.position.x +10
			fire_effect.flip_h = false
			fire_effect.position.x = character.position.x +35
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#Play animation
	if is_on_floor():
		if direction == 0:
			character.play("tabea")
		else: 
			character.play("tabea_walking")
	else:
		character.play("tabea_jump")

	move_and_slide()

func _on_shot_timer_timeout():
	fire_effect.visible=false
	timer.stop()
