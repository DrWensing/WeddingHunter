extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
#@onready var cam = get_tree().root.get_node("/root/MultiTargetCam")

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.show_message("Level 3: Das Untier")
