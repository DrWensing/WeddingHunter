extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@onready var can_interact = true

var interact: Callable = func():
	pass

func _on_body_entered(body):	
	if can_interact:
		print("Body entered")
		InteractionManager.register_area(self)
