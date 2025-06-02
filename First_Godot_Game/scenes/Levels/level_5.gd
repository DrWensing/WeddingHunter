extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var BossMusic = $BossMusic
@onready var Boss_Godzilla = $Boss_Godzilla
@onready var NextLevelPortal = $NextLevel

var boss_activated = false
var boss_alive = true

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.show_message("Level 5: Tokia \n  2016 n. Chr.")
	Boss_Godzilla.steps()

func _process(delta):
	if !boss_activated:
		if tabea.position.x > 525 or henrik.position.x > 525:
			boss_activate()
			boss_activated = true
	
	if not is_instance_valid(Boss_Godzilla):
		Boss_defeated()
		boss_alive = false
		
	if boss_alive:
		Boss_Godzilla.change_position()

func boss_activate():	
	MultiTargetCam.reset()
	MultiTargetCam.manual_set(Vector2(1400, 140), Vector2(2, 2))
	Boss_Godzilla.rawr()
	BossMusic.play()
	
func Boss_defeated():
	BossMusic.stop()
	HUD.show_message("Henrik & Tabea: \n Der König der Monster wurde gerade entthront")
	$NextLevel.global_position = Vector2(1500,270)
