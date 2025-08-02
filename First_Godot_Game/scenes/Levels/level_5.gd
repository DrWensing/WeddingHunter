extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var BossMusic = $BossMusic
@onready var Boss_Godzilla = $Boss_Godzilla
@onready var NextLevelPortal = $NextLevel
@onready var ingredient = $dutch_ingredient

var boss_activated = false
var boss_alive = true

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	ingredient.set_type('grape')
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.visible = true
	HUD.show_message("Level 5: Tokio \n  2016 n. Chr.")
	Boss_Godzilla.steps()
	$Music.play()

func _process(delta):
	if !boss_activated:
		if tabea.position.x > 525 or henrik.position.x > 525:
			boss_activate()
			boss_activated = true
			$Music.stream_paused=true;
	
	if not is_instance_valid(Boss_Godzilla):
		Boss_defeated()
		boss_alive = false
		
	if boss_alive:
		Boss_Godzilla.change_position()

func boss_activate():	
	MultiTargetCam.reset()
	MultiTargetCam.manual_set(Vector2(1400, 140), Vector2(2, 2))	
	Boss_Godzilla.activate()
	BossMusic.play()
	
func Boss_defeated():
	BossMusic.stop()
	$Music.stream_paused=false
	HUD.show_message("Henrik & Tabea: \n Der König der Monster wurde soeben entthront")
	$NextLevel.global_position = Vector2(650,25)
