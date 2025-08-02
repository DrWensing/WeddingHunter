extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var hermann = %Dog 
@onready var lama = $Lama
@onready var ingredient = $dutch_ingredient

var lama_activated = false

func _ready():
		
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	ingredient.set_type('cauliflower')
	$DutchOven.pause()
	$Music.play()

	HUD.visible = true
	HUD.show_message("Level 1: \nTabea und Henrik sind in den Flitterwochen...im Wald. Plötzlich bleibt der Wagen liegen. Sie sind auf sich gestellt...", 5.0)

func _process(delta):
	#message box portal
	if get_max_player_ypos() < -300 and get_max_player_xpos() < 1500:
		HUD.show_message("Ein Portal?!",3.0)
	
	#text box Lama
	if lama_activated == false and Main.get_min_player_distance_to_node(henrik, tabea, lama) < 50:
		HUD.show_message("Lama: 'Mist...mir fehlen noch Zutaten. So lohnt es sich gar nicht den Dutch Oven anzuschmeißen...'",3.0)
	
func get_max_player_xpos():
	return max(henrik.global_position.x,tabea.global_position.x)
	
func get_max_player_ypos():
	return max(henrik.global_position.y,tabea.global_position.y)
