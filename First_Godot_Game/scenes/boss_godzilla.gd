extends Node2D

var direction = -1
@onready var hp = 500
@onready var health_bar = $HealthBar
@onready var can_move = false
@onready var height_level = 1

func _ready():
	$laser.hide_animation()	
	health_bar.initialize(hp)
	disable_laser_killzone()

func set_height_level(stage_ind):
	#update present stage
	height_level = stage_ind
	
	#set y-position of godzilla
	var y_dict = {1: 0, 2: 50, 3: 100, 4: 150}
	self.global_position.y = y_dict[stage_ind]
	
func change_position():
	if can_move:
		if height_level == 4:
			set_height_level(randi_range(1,3))
		else:
			set_height_level(4)
		$MoveTimer.start(7.0)
		$FireTimer.start(5.0)
		$ChargeTimer.start(2.0)
		can_move = false
		$laser.hide_animation()

func rawr():
	$Roar.play()
	
func activate():
	can_move = true
	rawr()
	change_position()
	
func steps():
	$GodzillaSteps.play()
	
func enable_laser_killzone():
	$KillZone_Laser/CollisionShape2D.disabled = false

func disable_laser_killzone():
	$KillZone_Laser/CollisionShape2D.disabled = true

func _on_move_timer_timeout():
	#once this times out, godzilla changes position
	can_move = true
	disable_laser_killzone()
	#print('Move timer timeout')

func _on_fire_timer_timeout():
	#once this times out, the attack animation starts
	$laser.show_animation()
	enable_laser_killzone()
	#print('Fire timer timeout')

func _on_charge_timer_timeout():
	#once this times out, the charge animation is shown
	$laser.charging()
	#print('Charge timer timeout')

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
