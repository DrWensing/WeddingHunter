extends Area2D

@onready var vx = 500.0
@onready var vy = 0.0 #typically zero
var direction = +1
@onready var dmg = 10 # default damage
@onready var timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	#make sure that fireball is deleted after certain flight time
	timer.start()

func _on_timer_timeout():
	#remove fireball after certain flight time
	#print('remove fireball after timeout')
	queue_free()

func _process(delta):
	if vx < 0:
		$AnimatedSprite2D.flip_h = true
		
	#move fireball	
	self.position.x += delta*self.vx 
	self.position.y += delta*self.vy 

func set_animation(animation_type):
	print("Set animation to ",animation_type)
	sprite.play(animation_type)
