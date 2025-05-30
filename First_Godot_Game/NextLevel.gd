extends Area2D

func _on_body_entered(body):
	print('Body entered new level')
	if body.name == "Player" or body.name == "Player2":
		print(body.name)
		Main.switch_to_next_level()
