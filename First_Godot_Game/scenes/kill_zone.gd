extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	body.velocity.y = -100
	timer.start()
	match body.name:
		'Player': 
			HUD.show_message("Game Over: Henrik wurde gekillt!")
		'Player2':
			HUD.show_message("Game Over: Tabea wurde gekillt!")
		'Dog':
			HUD.show_message("Game Over: Hermann wurde gekillt!")

func _on_timer_timeout():	
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	
