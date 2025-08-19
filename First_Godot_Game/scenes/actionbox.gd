extends Node2D

@onready var correct = true
@onready var activated = false

func _ready():
	$Area2D/CollisionShape2D.disabled = true

func _on_area_2d_area_entered(area):
	if area.name.begins_with('Fireball'):
		

		if correct:
			$win_sound.play()
			$AnimatedSprite2D.frame = 3
		else:
			$fail_sound.play()
			$AnimatedSprite2D.frame = 5
		
		activated = true
		area.free()
		
func set_label(text):
	$Area2D/CollisionShape2D.disabled = false
	$Label.text = text
	activated = false
	$AnimatedSprite2D.frame = 0
	
func disable():
	$Area2D/CollisionShape2D.disabled = false
	hide()
