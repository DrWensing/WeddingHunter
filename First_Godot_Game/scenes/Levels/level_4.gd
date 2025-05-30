extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var BossMusic = $BossMusic
#@onready var cam = get_tree().root.get_node("/root/MultiTargetCam")
@onready var NextLevelPortal = $NextLevel

@onready var Warnung_ausgesprochen = false

func _ready():
	MultiTargetCam.add_target(henrik)
	MultiTargetCam.add_target(tabea)
	#set camera as the active one
	MultiTargetCam.make_current()
	
	henrik.equip_gun()
	tabea.equip_gun()
	
	HUD.show_message("Level 4: Khazad-dûm - Die Minen von Moria")
	
func _process(delta):
	if !Warnung_ausgesprochen:
		if henrik.position.x > 500 or tabea.position.x > 500:
			HUD.show_message("Bei Balin's Bart was treiben Menschen in Khazad-dûm?\n Wie dem auch sei, geht ruhig weiter. Hier gibt es keinerlei Gefahren",10.0)
			Warnung_ausgesprochen = true
	
