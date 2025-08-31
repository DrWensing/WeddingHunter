extends AnimatableBody2D

@onready var hp = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.modulate= Color(hp/100.0,hp/100.0,hp/100.0,hp/100.0)
	#print(hp)
	if hp<=0:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name.begins_with("Player"):
		$DecayTimer.start(0.5)

func _on_decay_timer_timeout():
	hp -= 5

func _on_area_2d_body_exited(body):
	if body.name.begins_with("Player"):
		$DecayTimer.stop()

