extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var BossMusic = $BossMusic
@onready var Boss_Bunny = $Boss_Bunny
@onready var NextLevelPortal = $NextLevel

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.show_message("Level 5: Tokia \n  2016 n. Chr.")
	
	
