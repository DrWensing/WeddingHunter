extends Node2D

@onready var henrik = %Player
@onready var tabea = %Player2
@onready var cam = get_tree().root.get_node("/root/MultiTargetCam")

func _ready():
	print(henrik)
	print(cam)
	print(tabea)
	
		
	cam.add_target(henrik)
	cam.add_target(tabea)
	#set camera as the active one
	cam.make_current()		
