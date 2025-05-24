extends Area2D

func _on_body_entered(body):
	print("Player is in area :)")
	

func _on_body_exited(body):
	print("Area empty :(")
