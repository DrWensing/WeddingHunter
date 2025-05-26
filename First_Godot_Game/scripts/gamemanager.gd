extends Node

@onready var ScoreLabel = %HUD/ScoreLabel
@onready var pause_menu = %HUD/PauseMenu
@onready var henrik = %Player
@onready var tabea = %Player2
@onready var game = $".."
@onready var projectile_container:Node = %projectiles
@onready var hud = %HUD
#@onready var enemy_container:Noe = %Enemies

@onready var cam = %MultiTargetCam

var score = 0
var weather = "sun"
var paused = false

func add_point():
	score += 1
	ScoreLabel.text = "Score: " + str(score) + " "

func _ready():
	#set camera such that henrik an tabea are both visible
	cam.add_target(henrik)
	cam.add_target(tabea)
	#set this camera as the active one
	#cam.current = true
	cam.make_current()
	
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
	
func show_message(str, time_delay):
	hud.show_message(str, time_delay)


