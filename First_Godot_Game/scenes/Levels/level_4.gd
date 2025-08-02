extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var BossMusic = $BossMusic
#@onready var cam = get_tree().root.get_node("/root/MultiTargetCam")
@onready var NextLevelPortal = $NextLevel
@onready var Boss_Balrog = $Boss_Balrog
@onready var zwockel = $Zwockel
@onready var ingredient = $dutch_ingredient

@onready var Warnung_ausgesprochen = false
@onready var boss_alive = true

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.visible = true
	HUD.show_message("Level 4: Khazad-dûm - Die Minen von Moria")
	ingredient.set_type('carotte')
	$Music.play()
	
func _process(delta):
	if !Warnung_ausgesprochen:
		if abs(henrik.position.x - zwockel.position.x) < 50 or abs(tabea.position.x - zwockel.position.x) < 50:
			HUD.show_message("Bei Balin's Bart was treiben Menschen in Khazad-dûm?\n Wie dem auch sei, geht ruhig weiter. Hier gibt es keinerlei Gefahren",10.0)
			Warnung_ausgesprochen = true
			
			
		#start boss music once tabea and henrik enter arena
	if not is_instance_valid(Boss_Balrog):
			Boss_defeated()
			boss_alive = false
	if boss_alive:
		if get_max_player_xpos() > 1000:
			if not BossMusic.playing:
				$Music.stream_paused = true
				BossMusic.play()
				Boss_Balrog.active = true
		
		#if Boss is close enough, perform attack, stop walking
		#player is pushed back
		if Boss_Balrog.position.x - get_max_player_xpos() < 100:
			Boss_Balrog.attack()
			if Boss_Balrog.position.x - henrik.position.x < 100:
				henrik.take_damage(30)				
				henrik.position.x = Boss_Balrog.position.x - 200
				henrik.global_position.x = max(henrik.global_position.x, 1050)
			if Boss_Balrog.position.x - tabea.position.x < 100:
				tabea.take_damage(30)
				tabea.position.x = Boss_Balrog.position.x - 200
				tabea.global_position.x = max(tabea.global_position.x,1050)

func get_max_player_xpos():
	return max(henrik.position.x,tabea.position.x)

func Boss_defeated():
	$Music.stream_paused=false
	BossMusic.stop()
	HUD.show_message("Henrik & Tabea: 'DU KOMMST NICHT VORBEI!' \n Weiter geht's")
	NextLevelPortal.global_position = Vector2(1500,270)

