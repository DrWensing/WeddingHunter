extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var BossMusic = $BossMusic
@onready var Boss_Bunny = $Boss_Bunny
@onready var warnung_ausgesprochen = false
@onready var boss_alive = true
@onready var NextLevelPortal = $NextLevel
@onready var ingredient = $dutch_ingredient
@onready var yspeed_zwockel = 0

var questions_answered = -1

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.visible = true
	HUD.show_message("Level 3: England 932 n.Chr.",4.0)
	$sound_intro.play()
	ingredient.set_type('tomato')
	$Music.play()
	
func setup_question_boxes():
	print('Setup Question boxes ', questions_answered)
	#reset boxes
	$ActionBox_1.activated = false
	$ActionBox_2.activated = false
	$ActionBox_3.activated = false
	
	#set up question boxes
	if questions_answered==0:
		$Fragetext.text = "Wie lautet euer Begehr?"
		$ActionBox_1.visible=true
		$ActionBox_2.visible=true
		$ActionBox_3.visible=true
		$ActionBox_1.correct = true
		$ActionBox_2.correct = false
		$ActionBox_3.correct = false
		$ActionBox_1.set_label("Wir sind auf der Suche nach einem Ersatzmotor")
		$ActionBox_2.set_label("Den Weg in die Zivilisation finden.")
		$ActionBox_3.set_label("Zum Mongolen zu gehen.")
	elif questions_answered==1:
		$Fragetext.text = "Wie heißt die Hauptstadt von Assyrien?"
		$ActionBox_1.correct = false
		$ActionBox_2.correct = true
		$ActionBox_3.correct = false
		$ActionBox_1.set_label("Weiß ich nicht, da bin ich noch nie gewesen.")
		$ActionBox_2.set_label("Assur")		
		$ActionBox_3.set_label("Bethlehem")
	elif questions_answered==2:
		$Fragetext.text = "Was ist die durchschnittliche \nGeschwindigkeit einer Schwalbe?"
		$ActionBox_1.correct = false
		$ActionBox_2.correct = false
		$ActionBox_3.correct = true
		$ActionBox_1.set_label("42 km/h")
		$ActionBox_2.set_label("35 km/h")
		$ActionBox_3.set_label("Einer europäischen oder asiatischen Schwalbe?")
	elif questions_answered>2:
		$ActionBox_1.disable()
		$ActionBox_2.disable()
		$ActionBox_3.disable()
		$Fragetext.hide()
		HUD.show_message("Wächter der Brücke des Todes: Ähm....weiß ich nicht...AHHHHHH",5.0)
		$ZwockelEjectTimer.start(2.0)
		$Bridge.appear()

func eject_players():
	#kicks players out of the screen
	MultiTargetCam.reset()
	var zoom_factor = Vector2(2,2)
	var camera_position = Vector2(-500,200)
	MultiTargetCam.manual_set(camera_position, zoom_factor)
	henrik.velocity += Vector2(-500,-2000)
	tabea.velocity += Vector2(-500,-2000)
	$EjectTimer.start(1.0)
	
func check_results():
	if (($ActionBox_1.correct == false) and ($ActionBox_1.activated == true)) \
		or (($ActionBox_2.correct == false) and ($ActionBox_2.activated == true)) \
		or (($ActionBox_3.correct == false) and ($ActionBox_3.activated == true)):
			eject_players()

func question_check():

	#set questions answered		
	if $ActionBox_1.activated == true \
	or $ActionBox_2.activated == true \
	or $ActionBox_3.activated == true:
		questions_answered += 1
		check_results()
		setup_question_boxes()

func _process(delta):
	
	$WaechterDerBrueckeDesTodes.position.y += yspeed_zwockel*delta
	
	question_check()

	if questions_answered == -1 and (henrik.position.x > -1000 or tabea.position.x > -1000):
		HUD.show_message("Wächter der Brücke: STOP! Wer will über die Brücke des Todes gehen, muss 3 mal Rede und Antwort stehen. Dann darf er die andere Seite sehen.",7.0)
		$story_waechter.play()
		questions_answered = 0
		setup_question_boxes()

	if !warnung_ausgesprochen and (henrik.position.x > 600 or tabea.position.x > 600):
		warnung_ausgesprochen = true
		HUD.show_message("Nehmt euch in Acht. Ein Untier durchstreift diese Gegend.",4.0)
		$sound_zwerg.play()

	#start boss music once tabea and henrik enter arena
	if boss_alive and not is_instance_valid(Boss_Bunny):
			Boss_defeated()
			boss_alive = false
			$sound_ende.play()
	if boss_alive:
		if henrik.position.x > 1000 or tabea.position.x > 1000:
			if not BossMusic.playing:
				BossMusic.play()
				$Music.stream_paused = true
				
		# Der Boss verfolgt die Spieler
		if henrik.position.x > 900:
			if tabea.position.x > Boss_Bunny.position.x and henrik.position.x > Boss_Bunny.position.x:
				Boss_Bunny.direction = +1
				Boss_Bunny.animated_sprite_2d.flip_h = false
			elif tabea.position.x < Boss_Bunny.position.x and henrik.position.x < Boss_Bunny.position.x:
				Boss_Bunny.direction = -1
				Boss_Bunny.animated_sprite_2d.flip_h = true

func Boss_defeated():
	$Music.stream_paused = false
	BossMusic.stop()
	HUD.show_message('Waidmannsheil. Das Untier wurde erlegt. Der Weg ist nun frei.',6.0)
	NextLevelPortal.global_position = Vector2(1270,820)

func _on_eject_timer_timeout():
	henrik.die()
	tabea.die()


func _on_zwockel_eject_timer_timeout():
	yspeed_zwockel = -500
	$eject_zwerg_sound.play()
	$story_waechter_eject.play()
