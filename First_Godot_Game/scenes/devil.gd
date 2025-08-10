extends CharacterBody2D

const SPEED = 300
const DMG_fireball = 20
const SPAWN_POINTS =  {0: Vector2(-1000,-15), #possible spawn points of minions
					   1: Vector2(-500,-15), 
					   2: Vector2(-1000,-60),
					   3: Vector2(-500,-60),
					   4: Vector2(-950,-100), 
					   5: Vector2(-550,-100), 
					   6: Vector2(-900,-150),
					   7: Vector2(-600,-150)}

var direction = 1
@onready var animation_sprite = $AnimatedSprite2D
@onready var hp = 50
@onready var health_bar = $HealthBar

@export var fireball_scene: PackedScene = preload("res://scenes/fireball_enemy.tscn")
@export var minion_scene: PackedScene = preload("res://scenes/demon.tscn")

var registered_player = []
var action_completed = false # boolean for 1-time actions per state

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- State Definitions ---
enum State {
	IDLE,
	MOVE,
	ATTACK,
	SUMMON,
	FIREBALL
}

var current_state = State.IDLE
var state_timer = 0.0

# --- References ---
@onready var anim = $AnimatedSprite2D

func _ready():
	change_state(State.IDLE)
	health_bar.initialize(hp)

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	state_timer -= delta
	if direction==1:
		anim.flip_h=false
	else:
		anim.flip_h=true
		
	match current_state:
		State.IDLE:
			state_idle(delta)
		State.MOVE:
			state_move(delta)
		State.ATTACK:
			state_attack(delta)
		State.SUMMON:
			state_summon(delta)
		State.FIREBALL:
			state_fireball(delta)
	
	move_and_slide()
	
func spawn():
	#spawn devil after minions are defeated
	self.global_position.x = -750
	self.global_position.y = -20
	$spawn_animation.play()
	$smoke.play()
	change_state(State.IDLE)
	$SpawnAnimationTimer.start(3.0)

func change_state(new_state: int):
	action_completed = false # boolean for 1-time actions per state
	current_state = new_state
	state_timer = 0.0
	match new_state:
		State.IDLE:
			anim.play("idle")
			state_timer = 1.5  # stay idle for 1.5s
		State.MOVE:
			anim.play("walk")
			state_timer = 2.0
		State.ATTACK:
			anim.play("attack")
			state_timer = 1.0
		State.FIREBALL:
			anim.play("cast_fireball")
			state_timer = 1.0
		State.SUMMON:
			anim.play("summon_minion")
			state_timer = 1.0

# --- State Logic ---
func state_idle(delta):
	if state_timer <= 0 and not registered_player.is_empty():
		change_state(State.MOVE)

func state_move(delta):
	# Example: Move horizontally
	if not registered_player.is_empty():
		var closest_player = get_closest_player()
		var x_distance_to_closest_player = closest_player.position.x - self.position.x 
		var y_distance_to_closest_player = closest_player.position.y - self.position.y 
		if abs(x_distance_to_closest_player)>40 or abs(y_distance_to_closest_player)>30:
			#follow player
			if x_distance_to_closest_player < 0:
				direction = -1
				animation_sprite.flip_h = false
			else:
				direction = +1
				animation_sprite.flip_h = true
	else:
		#if no player is present simply move right
		direction = +1
	
	velocity.x = SPEED*direction*delta
	if state_timer <= 0:
		#after timer ended either summon a minion (30% chance) or cast fireball
		if randf()<0.3:
			change_state(State.SUMMON)
		else:
			change_state(State.FIREBALL)

func state_attack(delta):
	if state_timer <= 0:
		change_state(State.IDLE)

func state_fireball(delta):
	# Example: shoot a bullet
	if not action_completed: # only fire once per attack cycle
		shot_fired(DMG_fireball)
		action_completed = true
	if state_timer <= 0:
		change_state(State.IDLE)

func state_summon(delta):
	if not action_completed: # only fire once per attack cycle
		print('state_summon minion called')	
		summon_minion()
		action_completed = true	
	if state_timer <= 0:
		change_state(State.IDLE)

func summon_minion():	
	var rand_position = SPAWN_POINTS[randi_range(0, 7)] # random position: 1,2 bottom, 3,4 first platform (L/R) and so on
	
	print('function summon minion called ', rand_position)
	#summons a demon minion
	var minion = minion_scene.instantiate()
	
	# set entry position of fireball
	minion.global_position = Vector2(rand_position[0],rand_position[1])

	#set direction of the fireball
	if minion.global_position.x > -750:
		minion.direction=-1
	else:
		minion.direction=+1

	#register fireball in its container
	%Enemies.add_child(minion)

func shot_fired(dmg):	
	#summons a fireball
	var projectile = fireball_scene.instantiate()
	var x_offset = -30
	var y_offset = -30	
	
	if direction:
		x_offset = x_offset *(-1)
	
	# set entry position of fireball
	projectile.global_position = self.global_position
	projectile.position.x += x_offset
	projectile.position.y += y_offset
	
	#set different fireball animation
	projectile.set_animation("ice_explosion")
	
	#set direction of the fireball
	projectile.direction = direction
		
	#set damage fireball can deal
	projectile.dmg = dmg
			
	#register fireball in its container
	Projectiles.add_child(projectile)
	$AttackTimer.start()

func get_closest_player():
	#only 1 player detected
	if registered_player.size()==1:
		return registered_player[0]
	
	#2 players:
	var dist0 = registered_player[0].position.x - self.position.x
	var dist1 = registered_player[1].position.x - self.position.x
	
	if abs(dist0) < abs(dist1):
		return registered_player[0]
	else:
		return registered_player[1]
	

#Take damage
func receive_damage(dmg):
	$hit_sound.play()
	health_bar.take_dmg(dmg)
	if health_bar.is_dead():
		print('Enemy slain!')
		Main.add_point()
		queue_free()

func _on_hit_box_area_entered(area):
	if area.name == "Fireball" or area.name.begins_with("@Area2D"):
		receive_damage(area.dmg)
		area.free()

func _on_alert_area_body_entered(body):
	if body.name.begins_with("Player"):
		registered_player.append(body)
		animation_sprite.play("walk")
		print('Registered ',body.name)


func _on_spawn_animation_timer_timeout():
	$spawn_animation.hide()
	$spawn_animation.visible=false
