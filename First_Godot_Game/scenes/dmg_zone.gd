extends Area2D

@onready var timer = $Timer

@onready var DMG = 30

func _on_body_entered(body):
	if body.name.begins_with("Player"):
		print("body ", body.name, " entered dmg zone")
		print(body.global_position - global_position)
		
		#knockback
		body.global_position -= body.global_position - global_position + Vector2(0,30)
		body.take_damage(DMG)
