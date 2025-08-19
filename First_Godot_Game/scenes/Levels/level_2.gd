extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var ingredient = $dutch_ingredient

var ende_notice_activated = false

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	ingredient.set_type('mais')
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.visible = true
	HUD.show_message("Level 2: Ballert euch den Weg frei.",3.0)
	$sound_einleitung.play()
	$Music.play()

func _process(delta):
	if ende_notice_activated == false and get_max_player_xpos() > 3300:
		HUD.show_message("Diese Portale scheinen Risse in der Raum-Zeit zu sein...Wo wir wohl jetzt rauskommen?",5.0)
		$sound_ende.play()
		ende_notice_activated = true
	
func get_max_player_xpos():
	return max(henrik.position.x,tabea.position.x)
