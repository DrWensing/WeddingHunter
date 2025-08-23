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

	$Platforms/MovingPlatform3.set_move_mode('y')
	$Platforms/MovingPlatform7.set_move_mode('y')
	$Platforms/MovingPlatform4.set_move_mode('y')
	$Platforms/MovingPlatform9.set_move_mode('y')
	$Platforms/MovingPlatform13.set_move_mode('y')
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.visible = true
	HUD.show_message("Level 6: Das Königreich OZ",4.0)

	$Music.play()
