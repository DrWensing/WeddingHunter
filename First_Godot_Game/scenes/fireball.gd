extends Area2D

@onready var vx = 500.0
@onready var direction
@onready var dmg = 10 # default damage

func _process(delta):
	self.position.x = self.position.x + delta*self.vx * self.direction
