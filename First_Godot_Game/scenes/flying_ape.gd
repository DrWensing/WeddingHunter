extends Node2D

@export var fireball_scene: PackedScene = preload("res://scenes/fireball_enemy.tscn")
var direction = 1
@onready var hp = 40
@onready var health_bar = $HealthBar
const UPDOWNSPEED = 20

var ydirection = 1

var attack_power = 25

func _ready():
	start_idle()
	health_bar.initialize(hp)
	
func start_idle():
	$IdleTimer.start(2.0)	
	
func start_attack():
	$AttackTimer.start(0.5) #casts fireball 0.5s after the animation started	

func shot_fired(dmg):
	
	var projectile = fireball_scene.instantiate()
	var offset = -20
	
	# set entry position of fireball
	projectile.global_position = self.global_position
	projectile.position.x += offset*direction
		
	#set damage fireball can deal
	projectile.dmg = dmg
			
	#register fireball in its container
	Projectiles.add_child(projectile)
	projectile.set_animation("purple")
	projectile.scale = Vector2(1.2, 1.2)
	
	#set direction of the fireball
	projectile.vx = projectile.vx*float(direction)
	
	
func _physics_process(delta):
	if direction==1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	position.y += UPDOWNSPEED*ydirection*delta
	
func receive_damage(dmg):
	health_bar.take_dmg(dmg)
	if health_bar.is_dead():
		print('Enemy slain!')
		Main.add_point()
		queue_free()

func _on_idle_timer_timeout():	
	#after idle for 1s start attack
	start_attack()

func _on_attack_timer_timeout():	
	#0.3s after the attack animation starts: cast fireball
	shot_fired(attack_power)
	start_idle()
	
func _on_hitbox_area_entered(area):
	if area.name == "Fireball" or area.name.begins_with("@Area2D"):
		receive_damage(area.dmg)
		area.free()


func _on_reverse_timer_timeout():
	ydirection *= -1
