extends Node

@onready var ScoreLabel = %HUD/ScoreLabel
@onready var pause_menu = %HUD/PauseMenu
@onready var henrik = %Player
@onready var tabea = %Player2
@onready var game = $".."

var score = 0
var weather = "rain"
var paused = false
var friendly_fire_enabled = true

func add_point():
	score += 1
	ScoreLabel.text = "Score: " + str(score) + " "

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()	
		Engine.time_scale = 0

	paused = !paused
	
func _on_test_area_2d_body_entered(body):
	pass # Replace with function body.

func _players_receive_guns():
	print("Henrik received gun")
	print("tabea received gun")
	henrik.equip_gun()
	tabea.equip_gun()

func deal_damage_in_area( x0, x1, y0, y1, dmg):
	print('Dealing damage in area')
	print(x0, y0)
	print(x1, y1)
	#need to find way to get all enemies...
	
	if friendly_fire_enabled:
		var x_tabea = tabea.position.x
		var y_tabea = tabea.position.y
		print(x_tabea, y_tabea)
		if x0 < x_tabea && x_tabea < x1 && y0 < y_tabea && y_tabea < y1:
			tabea.take_damage(dmg)

