extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var hp = 100
var ammo = 5
var gun_equipped = false
var movement_eneabled = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#@onready var hud = %HUD
@onready var character = $Character
@onready var gun = $Gun
#@onready var hp_bar_henrik   = %hud/hp_bar_henrik
#@onready var ammo_bar_henrik = %hud/ammo_henrik
@onready var fire_effect = $FireEffect
@onready var timer = $ShotTimer
@onready var gunshot = $gunshot
@onready var reload = $reload
@onready var jump_sound = $jump
@onready var death_sound = $death_sound
@onready var projectile_container = %projectile_container

@export var projectilePrefab:PackedScene

func _ready():
	HUD.set_hp_henrik(hp)
	
func get_distance_to(node):
	#computes the distance between Player and the given node
	return self.position.distance_to(node.position)

func die():
	death_sound.play()
	HUD.set_hp_henrik(0)
	Main.player_died(self)

func take_damage(dmg):
	if hp <= 0:
		#already dead
		return
	$damage_sound.play()
	hp -= dmg
	HUD.set_hp_henrik(hp)
	print('Henrik HP remaining ' + str(hp))
	
	if hp <= 0:
		die()

func equip_gun():	
	gun.visible=true
	gun_equipped = true
	fire_effect.visible=false
	HUD.set_ammo_henrik(ammo)
	reload.play()
	
func unequip_gun():
	gun.visible = false
	gun_equipped = false
	fire_effect.visible=false

func shoot():
	if gun_equipped:
		if ammo > 0:
			if timer.is_stopped():
				ammo -= 1
				HUD.set_ammo_henrik(ammo)
				timer.start(0.7)
				fire_effect.visible=true
				gunshot.play()
				#apply damage to everything within range
				var dmg=20
				shot_fired(dmg)

		else:
			print('Out of ammo: reloading')
			reload.play()
			ammo = 5
			HUD.set_ammo_henrik(ammo)
			timer.start(2.5)

func shot_fired(dmg):	
	var projectile = projectilePrefab.instantiate()
	var offset = 20
	var direction = character.flip_h
	
	if direction:
		offset = offset *(-1)
	
	# set entry position of fireball
	projectile.global_position = character.global_position
	projectile.position.x += offset
	
	#set direction of the fireball
	if direction:
		projectile.direction=-1
	else:
		projectile.direction=+1
		
	#set damage fireball can deal
	projectile.dmg = dmg
			
	#register fireball in its container
	Projectiles.add_child(projectile)
	
func jump():
	velocity.y = JUMP_VELOCITY
	jump_sound.play()
	
func _physics_process(delta):
	if not movement_eneabled:
		pass
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	#take_damage(delta/10)
	
	# Handle shoot rifle
	if Input.is_action_just_pressed("shoot"):
		shoot()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
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
			character.play("henrik")
		else: 
			character.play("henrik_walking")
	else:
		character.play("henrik_jump")

	move_and_slide()

func _on_shot_timer_timeout():
	fire_effect.visible=false
	timer.stop()
