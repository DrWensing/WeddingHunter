extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var hermann = %Dog

var lama_activated = false
var ignition_counter = 0 # plays sound a couple of times

func _ready():
		
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.movement_enabled = false
	tabea.movement_enabled = false
	hermann.visible = false
	henrik.hide()
	tabea.hide()	

	$Car.SPEED = 30
	$Car.broken = false
	
	#$Music.play()
	$car_engine_switch_off.play()
	$Car.hide_smoke()
	$Car.show_henrik_tabea()

	HUD.visible = false
	#HUD.show_message("Level 1: \nTabea und Henrik sind in den Flitterwochen...im Wald. Plötzlich bleibt der Wagen liegen. Sie sind auf sich gestellt...", 5.0)

func _physics_process(delta):

	#if $Logo.position.x < 300:
	$Logo.position.x += 100*delta
	#else:
	#	$Logo.modulate.a -= delta*0.05

func _on_car_engine_switch_off_finished():
	$engine_dead.play()
	$Car.broken = true
	$Car.SPEED = 0
	$Car.show_smoke()


func _on_engine_dead_finished():
	#play sound 3 times and then start level
	ignition_counter += 1
	if ignition_counter == 2:
		#break loop, go to level 1
		$Car.hide_henrik_tabea()
		henrik.show()
		tabea.show()
		Main.switch_to_next_level()
	else:
		#repeat sound
		$engine_dead.play()
