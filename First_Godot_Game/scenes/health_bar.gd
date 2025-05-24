extends Node2D

@onready var maxhp = 30
@onready var hp = 30

@onready var progressbar = $TextureProgressBar

func initialize(max_hp):
	maxhp = max_hp
	hp = max_hp
	set_hp()
	
func set_hp():
	progressbar.max_value=maxhp
	progressbar.min_value=0
	progressbar.value = hp
	
func take_dmg(dmg):
	hp -= dmg
	set_hp()

func is_dead():
	return hp <= 0 
