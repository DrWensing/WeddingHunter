extends Node2D

const DMG_per_tick = 2
const activation_time = 2.0 #lava will not deal damage right at the start
@onready var decay_time = 4.0 #lava stays active for this time

# player inside the area
var player_inside: Node = null

func _ready():	
	$ActivationTimer.start(activation_time)
	$AnimatedSprite2D.play("activation")

func _on_area_2d_body_entered(body):
	#player enters
	if body.name=="Player2" or body.name=="Player":
		player_inside = body
		$DamageTimer.start(0.2)

func _on_decay_timer_timeout():
	#lave floor vanishes once the decay time is over
	queue_free()

func _on_activation_timer_timeout():
	#lave floor will now deal damage
	$DecayTimer.start(decay_time)
	$AnimatedSprite2D.play("damage_phase")

func _on_area_2d_body_exited(body):
	player_inside = null

func _on_damage_timer_timeout():
	if $AnimatedSprite2D.animation == "damage_phase":
		if player_inside != null:
			player_inside.take_damage(DMG_per_tick)
