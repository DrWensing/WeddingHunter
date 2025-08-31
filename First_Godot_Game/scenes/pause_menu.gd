extends Control

func _ready():
	$Steuerung.visible=false

func _on_resume_pressed():
	resume_game()
	
func _on_quit_pressed():
	get_tree().quit()
	
func _on_restart_pressed():
	get_tree().reload_current_scene()
	resume_game()

func pause_game():
	print('Pause game')
	get_tree().paused = true
	#visible = true
	
func resume_game():
	print('Resume game')
	get_tree().paused = false
	#visible = false

func _process(delta):
	#check if ESC is pressed
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == false:
			print("esc pressed -> pause")
			pause_game()

func _on_option_button_item_selected(index):
	#choose level
	Main.score = 0
	#change to level
	Main.load_level(index+1)


func _on_button_pressed():
	$Steuerung.visible = not $Steuerung.visible
