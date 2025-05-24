extends Control

func _on_resume_pressed():
	Input.action_press("pause")
	#game_manager.pauseMenu()
	
func _on_quit_pressed():
	get_tree().quit()
