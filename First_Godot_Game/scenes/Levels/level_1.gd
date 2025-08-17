extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var hermann = %Dog 
@onready var lama = $Lama
@onready var ingredient = $dutch_ingredient

var lama_activated = false
var portal_activated = false

func _ready():
		
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	ingredient.set_type('cauliflower')
	$DutchOven.pause()
	$Music.play()

	HUD.visible = true
	HUD.show_message("Level 1: Tabea und Henrik sind in den Flitterwochen, doch der Wagen bleibt plötzlich liegen. Sie brauchen einen neuen Motor...", 9.2)
	$intro.play()
	
func _process(delta):
	#message box portal
	if get_max_player_ypos() < -300 and get_max_player_xpos() < 1500 and portal_activated == false:
		HUD.show_message("Nanu, was ist das? Etwa ein Portal?!",4.0)
		$portal_sound.play()
		portal_activated = true
	
	#text box Lama
	if lama_activated == false and Main.get_min_player_distance_to_node(henrik, tabea, lama) < 50:
		HUD.show_message("Lama: 'Mist...mir fehlen noch Zutaten. So lohnt es sich gar nicht den Dutch Oven anzuschmeißen...'",4.0)
		$lama_sound.play()
		lama_activated = true
		
func get_max_player_xpos():
	return max(henrik.global_position.x,tabea.global_position.x)
	
func get_max_player_ypos():
	return max(henrik.global_position.y,tabea.global_position.y)
