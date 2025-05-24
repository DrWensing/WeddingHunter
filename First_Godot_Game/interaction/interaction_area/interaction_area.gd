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
	
func _on_body_exited(body):
	if can_interact:
		print("Body left")
		#if self.get_overlapping_bodies().size() == 0:
		InteractionManager.unregister_area(self)

#func _disable():
#	print('Disable interaction area')
#	self.can_interact = false
#	InteractionManager.unregister_area(self)
