extends Area2D
class_name Fireball_Enemy

@onready var vx = 500.0
@onready var vy = 0.0 #typically zero
@onready var dmg = 10 # default damage
@onready var timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flipsprite = true


func _ready():
	#make sure that fireball is deleted after certain flight time
	timer.start()
	self.collision_layer =2 
	self.collision_mask = 2
	self.z_index = +2 #make sure this is always shown on top

func _on_timer_timeout():
	#remove fireball after certain flight time
	#print('remove fireball after timeout')
	queue_free()

func _process(delta):
	if vx < 0:
		$AnimatedSprite2D.flip_h = flipsprite
	else:
		$AnimatedSprite2D.flip_h = not flipsprite
		
	#move fireball	
	self.position.x += delta*self.vx 
	self.position.y += delta*self.vy 

func set_animation(animation_type):
	sprite.play(animation_type)
