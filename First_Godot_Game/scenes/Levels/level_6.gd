extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var ingredient = $dutch_ingredient
@onready var lama = $Lama
@onready var dutch_oven = $DutchOven

var lama_activated = false
var auto_text_activated = false
var motor_collected = false

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	ingredient.set_type('carotte')
	dutch_oven.pause()
	
	henrik.equip_gun()
	tabea.equip_gun()
	$Music.play()
	
	HUD.visible = true
	HUD.show_message("Level 6: Wir sind wieder zurück?")

func _process(delta):
	if lama_activated == false and Main.get_min_player_distance_to_node(henrik, tabea, lama) < 50:		
		#count collected ingredients
		var N_ingredients = 0
		for i in HUD.ingredients_collected:
			N_ingredients+=int(i)
		
		if N_ingredients <= 2:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Man hab ich Hunger...schade, dass ihr nicht alle Zutaten dabei habt'",3.0)
		if N_ingredients > 2 and N_ingredients < 4:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Ihr habt " + str(N_ingredients) + " Zutaten eingesammelt, aber das reicht noch nicht.'",3.0)
		if N_ingredients >= 4 and N_ingredients < 6:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Ihr habt " + str(N_ingredients) + " Zutaten eingesammelt, aber etwas fehlt noch...'",3.0)
		if N_ingredients >= 5:
			HUD.show_message("Lama: 'Ihr habt alle Zutaten gesammelt! Ich schmeiß den Dutch Oven an!!!'",3.0)		
			dutch_oven.play()
			$win_sound.play()
	
	if auto_text_activated == false and get_min_player_xpos() < 275: 
		auto_text_activated = true
		HUD.show_message("Ach Mist...stimmt ja, der Wagen ist noch kaputt. Moment mal ... das Schild war doch vorhin noch nicht da?", 5.0)
	
	#switch from forest to hell
	if get_min_player_xpos() < -60:
		$ParallaxBackground.hide()
		$ParallaxBackground2.show()		
	else: 
		$ParallaxBackground.show()
		$ParallaxBackground2.hide()
		
	
	if motor_collected and get_min_player_xpos() < 225:
		HUD.show_message("Der neue Motor ist ruck-zuck eingebaut und der Wagen ist wie neu! Die Brüggemanns können jetzt ihre Flitterwochen genießen")
		$Car.repair()
		henrik.visible=false
		henrik.movement_eneabled=false
		
		tabea.visible=false
		tabea.movement_eneabled=false
		
		$Dog.visible = false
		$Music.stop()
		
		$honk.play()
		$car_starting.play()
		
		#prevents calling this sequence again and again
		motor_collected = false
		
	
func get_max_player_xpos():
	return max(henrik.position.x,tabea.position.x)
	
func get_min_player_xpos():
	return min(henrik.position.x,tabea.position.x)


func _on_motor_tree_exited():
	#motor collected -> back to car
	henrik.global_position.x = 250
	tabea.global_position.x = 260
	$Dog.global_position.x = 240
	
	henrik.global_position.y = -300
	tabea.global_position.y = -300
	$Dog.global_position.y = -300
	
	motor_collected = true
	

func _on_honk_finished():
	$Car.SPEED = 150


func _on_car_starting_finished():
	#nachdem die Animation abgelaufen ist -> Abspann
	Main.switch_to_next_level()
