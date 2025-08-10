extends Area2D

@onready var vx = 500.0
var direction = +1
@onready var dmg = 10 # default damage
@onready var timer = $Timer

func _ready():
	#make sure that fireball is deleted after certain flight time
	timer.start()

func _on_timer_timeout():
	#remove fireball after certain flight time
	#print('remove fireball after timeout')
	queue_free()

func _process(delta):
	#move fireball
	self.position.x += delta*self.vx * self.direction

func set_animation(animation_type):
	print('set fireball animation to ',animation_type)
	$AnimatedSprite2D.play(animation_type)
	$AnimatedSprite2D.animation = animation_type
	
