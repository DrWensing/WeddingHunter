extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body.name=="Player2" or body.name=="Player":
		body.die()
