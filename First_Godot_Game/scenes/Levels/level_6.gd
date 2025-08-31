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
	MultiTargetCam.min_zoom = 1.5
	MultiTargetCam.max_zoom = 5

	$Platforms/MovingPlatform3.set_move_mode('y')
	$Platforms/MovingPlatform7.set_move_mode('y')
	$Platforms/MovingPlatform4.set_move_mode('y')
	$Platforms/MovingPlatform9.set_move_mode('y')
	$Platforms/MovingPlatform13.set_move_mode('y')
	$Enemies/FlyingApe2.direction = -1
	$Enemies/FlyingApe3.direction = -1
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.visible = true
	HUD.show_message("Level 6: Das Königreich Oz",4.0)
	$story_intro.play()

	$Music.play()
	
	#to trigger equiping doppelgewehr if available
	Main.try_equip_doppelgewehr()
	
func _process(delta):
	if boss_activated == false and (henrik.global_position.y <=-1250 or tabea.global_position.y <= -1250):
		boss_activated = true
		$Witch.activate()
		$Music.stop()
		$BossMusic.play()

func _on_witch_tree_exited():	
	$NextLevel.global_position = Vector2(-600,-1400)
	HUD.show_message("Ihr habt die Hexe des Ostens bezwungen",5.0)
	#$story_boss_defeated.play()
	$BossMusic.stop()
	$Music.play()
	$story_ende.play()
