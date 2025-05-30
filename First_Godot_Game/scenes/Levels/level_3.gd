extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var BossMusic = $BossMusic
@onready var Boss_Bunny = $Boss_Bunny
#@onready var cam = get_tree().root.get_node("/root/MultiTargetCam")
@onready var warnung_ausgesprochen = false
@onready var boss_alive = true
@onready var NextLevelPortal = $NextLevel

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.show_message("Level 3: Das Untier")
	

func _process(delta):
	
	if !warnung_ausgesprochen and (henrik.position.x > 600 or tabea.position.x > 600):
		warnung_ausgesprochen = true
		HUD.show_message("Nehmt euch in Acht. Ein Untier durchstreift diese Gegend.",3.0)
	
	#start boss music once tabea and henrik enter arena
	if not is_instance_valid(Boss_Bunny):
			Boss_defeated()
			boss_alive = false
	if boss_alive:
		if henrik.position.x > 1000 or tabea.position.x > 1000:
			print('Start Music')
			if not BossMusic.playing:
				BossMusic.play()
				
		# Der Boss verfolgt die Spieler
		if henrik.position.x > 900:
			if tabea.position.x > Boss_Bunny.position.x and henrik.position.x > Boss_Bunny.position.x:
				Boss_Bunny.direction = +1
				Boss_Bunny.animated_sprite_2d.flip_h = false
			elif tabea.position.x < Boss_Bunny.position.x and henrik.position.x < Boss_Bunny.position.x:
				Boss_Bunny.direction = -1
				Boss_Bunny.animated_sprite_2d.flip_h = true
	
		
	
func Boss_defeated():
	BossMusic.stop()
	HUD.show_message('Waidmannsheil. Das Untier wurde erlegt. Der Weg ist nun frei.')
	NextLevelPortal.global_position = Vector2(1150,950)
	NextLevelPortal.global_position = Vector2(1270,820)
	
	
