extends Area2D

@onready var timer = $Timer
@onready var hud = %HUD

func _on_body_entered(body):
	#hud.show_message('Es hat begonnen!')
	#hud.show_message( " died!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	body.velocity.y = -100
	timer.start()

func _on_timer_timeout():	
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	
