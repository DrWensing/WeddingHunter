extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var ingredient = $dutch_ingredient
@onready var lama = $Lama
@onready var dutch_oven = $DutchOven

@export var lava_scene: PackedScene = preload("res://scenes/lava_floor.tscn")

var lama_activated = false
var auto_text_activated = false
var motor_collected = false
var devil_spawned = false
var scene_changed = false

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
	$story_intro.play()

func summon_lava(position):
	#summons a demon minion
	var lava = lava_scene.instantiate()
	
	# set entry position of fireball
	lava.global_position = position

	#register fireball in its container
	%Enemies.add_child(lava)
	lava.decay_time = 20

func _process(delta):
	if lama_activated == false and Main.get_min_player_distance_to_node(henrik, tabea, lama) < 50:
		#count collected ingredients
		var N_ingredients = 0
		for i in HUD.ingredients_collected:
			N_ingredients+=int(i)
		
		if N_ingredients <= 2:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Man hab ich Hunger...schade, dass ihr nicht alle Zutaten dabei habt'",6.0)
			$story_lama_opt1.play()
		if N_ingredients > 2 and N_ingredients < 4:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Ihr habt " + str(N_ingredients) + " Zutaten eingesammelt, aber das reicht noch nicht.'",6.0)
			$story_lama_opt2.play()
		if N_ingredients >= 4 and N_ingredients < 6:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Ihr habt " + str(N_ingredients) + " Zutaten eingesammelt, aber etwas fehlt noch...'",6.0)
			$story_lama_opt3.play()
		if N_ingredients >= 6:
			HUD.show_message("Lama: 'Ihr habt alle Zutaten gesammelt! Ich schmeiß den Dutch Oven an!!!'",6.0)		
			$story_lama_opt4.play()
			dutch_oven.play()
			$win_sound.play()
		lama_activated = true
	
	if devil_spawned == false and not is_instance_valid($Demon) and not is_instance_valid($Demon2):
		#boss fight begins when the first minions are defeated
		devil_spawned = true
		
		$Music.stop()
		$SpawnMusic.play()
		$BossSpawnTimer.start(20)
		summon_lava(Vector2(-725,-15))
		summon_lava(Vector2(-750,-15))
		summon_lava(Vector2(-775,-15))
		summon_lava(Vector2(-800,-15))
		summon_lava(Vector2(-825,-15))
		summon_lava(Vector2(-700,-15))
	
	if auto_text_activated == false and get_min_player_xpos() < 275: 
		auto_text_activated = true
		HUD.show_message("Ach Mist...stimmt ja, der Wagen ist noch kaputt. Moment mal ... das Schild war doch vorhin noch nicht da?", 7.0)
		$story_car_parts.play()
		
	#switch from forest to hell
	if get_min_player_xpos() < -60 and scene_changed == false:		
		scene_changed = true
		$BossLaughing.play()
		HUD.show_message("???: HAHAHAHA",2.0)

	if get_min_player_xpos() < -60:
		$ParallaxBackground.hide()
		$ParallaxBackground2.show()
	else:
		$ParallaxBackground.show()
		$ParallaxBackground2.hide()
	
	if motor_collected and get_min_player_xpos() < 225:
		HUD.show_message("Der neue Motor ist ruck-zuck eingebaut und der Wagen ist wie neu! Die Brüggemanns können jetzt ihre Flitterwochen genießen",6.0)
		$story_repair_car.play()
		
		$Car.repair()
		henrik.visible=false
		henrik.movement_enabled=false
		
		tabea.visible=false
		tabea.movement_enabled=false
		
		if is_instance_valid($Dog):
			$Dog.visible = false
		$Music.stop()
		
		$CarTimer.start(1.0)
		
		#prevents calling this sequence again and again
		motor_collected = false
		
	
func get_max_player_xpos():
	return max(henrik.position.x,tabea.position.x)
	
func get_min_player_xpos():
	return min(henrik.position.x,tabea.position.x)

func _on_motor_tree_exited():
	#motor collected -> back to car
	if is_instance_valid($Dog): #hotfix, this function is also called when the scene is reloaded appearantly
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

func _on_devil_tree_exited():
	$motor.global_position = Vector2(-750,-150)
	HUD.show_message("Ihr habt den Teufel bezwungen...als Preis bekommt ihr den Motor von seinem Auto.",5.0)
	$story_boss_defeated.play()
	$BossMusic.stop()
	$BossDefeated.play()

func _on_boss_spawn_timer_timeout():
	$Devil.spawn()

func _on_spawn_music_finished():
	#once tenacious d intro is finished: start suno music
	$BossMusic.play()


func _on_car_timer_timeout():
	#nachdem henrik und tabea im wagen sitzen starte die sounds
	$honk.play()
	$car_starting.play()
