extends AnimatableBody2D

const SPEED = 50
@onready var direction = 1
@onready var movemode = 'x'

func _physics_process(delta):
	if movemode == 'x':
		position.x += SPEED*delta*direction
	elif movemode =='y':
		position.y += SPEED*delta*direction

func _on_dir_change_timer_timeout():
	#flip direction everytime timer resets
	direction *= -1

func set_move_mode(mode):
	movemode = mode
