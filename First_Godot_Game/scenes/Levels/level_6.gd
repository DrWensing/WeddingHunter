extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var ingredient = $dutch_ingredient
@onready var lama = $Lama
@onready var dutch_oven = $DutchOven

var lama_activated = false

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	ingredient.set_type('carotte')
	dutch_oven.pause()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	
	HUD.show_message("Level 6: Wir sind wieder zurück?")

func _process(delta):
	if lama_activated == false and Main.get_min_player_distance_to_node(henrik, tabea, lama) < 50:		
		#count collected ingredients
		var N_ingredients = 0
		for i in HUD.ingredients_collected:
			N_ingredients+=int(i)
		
		if N_ingredients <= 2:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Man hab ich Hunger...'",3.0)			
		if N_ingredients > 2 and N_ingredients < 4:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Ihr habt " + str(N_ingredients) + " eingesammelt, aber das reicht noch nicht.'",3.0)
		if N_ingredients >= 4 and N_ingredients < 6:
			HUD.show_message("Lama: 'Da seid ihr ja wieder. Ihr habt " + str(N_ingredients) + " eingesammelt, aber etwas fehlt noch...'",3.0)
		if N_ingredients >= 5:
			HUD.show_message("Lama: 'Ihr habt alle Zutaten gesammelt! Ich schmeiß den Dutch Oven an!!!'",3.0)		
			dutch_oven.play()
	
func get_max_player_xpos():
	return max(henrik.position.x,tabea.position.x)
