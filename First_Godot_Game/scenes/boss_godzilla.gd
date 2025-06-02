extends Node2D

var direction = -1
@onready var hp = 300
@onready var health_bar = $HealthBar
@onready var can_move = true



func _ready():
	$laser.hide_animation()	
	health_bar.initialize(hp)

func set_height_level(stage_ind):
	var y_dict = {1: 0, 2: 50, 3: 100, 4: 150}
	
	self.global_position.y = y_dict[stage_ind]
	
func change_position():
	if can_move:
		set_height_level(randi_range(1,4))
		$MoveTimer.start()
		$FireTimer.start()
		$ChargeTimer.start()
		can_move = false
		$laser.hide_animation()

func rawr():
	$Roar.play()
	
func steps():
	$GodzillaSteps.play()

func _on_move_timer_timeout():
	#once this times out, godzilla changes position
	can_move = true
	print('Move timer timeout')

func _on_fire_timer_timeout():
	#once this times out, the attack animation starts
	$laser.show_animation()
	#TODO: activate killzone on laser beam
	print('Fire timer timeout')

func _on_charge_timer_timeout():
	#once this times out, the charge animation is shown
	$laser.charging()
	print('Charge timer timeout')

func receive_damage(dmg):
	health_bar.take_dmg(dmg)
	if health_bar.is_dead():
		print('Enemy slain!')
		Main.add_point()
		queue_free()

func _on_hit_box_area_entered(area):
	if area.name == "Fireball" or area.name.begins_with("@Area2D"):
		receive_damage(area.dmg)
		area.free()
