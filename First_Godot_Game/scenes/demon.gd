extends Node2D

@export var fireball_scene: PackedScene = preload("res://scenes/fireball_enemy.tscn")
var direction = 1
var on_cooldown = 0

var attack_power = 10

func _ready():
	$AttackTimer.start()

func shot_fired(dmg):
	$AnimatedSprite2D.play("attack")
	
	var projectile = fireball_scene.instantiate()
	var offset = -30
	#var direction = character.flip_h	
	
	if direction:
		offset = offset *(-1)
	
	# set entry position of fireball
	projectile.global_position = self.global_position
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
	$AttackTimer.start()
	
func _physics_process(delta):
	if direction==1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_timer_timeout():
	shot_fired(attack_power)


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("idle")
