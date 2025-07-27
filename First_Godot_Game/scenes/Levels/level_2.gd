extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var ingredient = $dutch_ingredient

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	ingredient.set_type('mais')
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	
	HUD.show_message("Level 2: Ballert euch den Weg frei.")

func _process(delta):
	if get_max_player_xpos() > 3300:
		HUD.show_message("Diese Portale scheinen Risse in der Raum-Zeit zu sein...Wo wir wohl jetzt rauskommen?",5.0)
	
func get_max_player_xpos():
	return max(henrik.position.x,tabea.position.x)
