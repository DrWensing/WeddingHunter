extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
#@onready var cam = get_tree().root.get_node("/root/MultiTargetCam")

func _ready():
		
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()		

	HUD.show_message("Tabea und Henrik sind in den Flitterwochen...im Wald. Plötzlich gibt der Wagen den Geist auf. Sie sind auf sich gestellt...", 5.0)

func _process(delta):
	if get_max_player_ypos() > 300 and get_max_player_xpos() < 1500:
		HUD.show_message("Ein Portal?!",3.0)

func get_max_player_xpos():
	return max(henrik.global_position.x,tabea.global_position.x)
	
func get_max_player_ypos():
	return max(henrik.global_position.y,tabea.global_position.y)
