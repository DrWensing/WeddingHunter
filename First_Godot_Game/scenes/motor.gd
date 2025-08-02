extends Node2D



func _on_area_2d_body_entered(body):
	$pickup_sound.play()
	$Area2D/CollisionShape2D.disabled = true  # Prevent further collisions
	$Sprite2D.visible = false      # Optional: hide coin immediately
	HUD.show_message("Ein neuer Motor?! Geile Sache!",4.0)

func _on_pickup_sound_finished():
	queue_free()
