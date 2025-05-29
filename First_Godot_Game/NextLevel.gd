extends Area2D

const LevelPath = "res://scenes/Levels/level_"

func _on_body_entered(body):
	if body.name == "Player" or body.name == "Player2":
		switch_to_next_level()
		
func switch_to_next_level():
		var current_scene = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene.to_int() + 1

		
		var next_level_scene = LevelPath +  str(next_level_number) + ".tscn"
		print("Switch to level " + next_level_scene)
		
		get_tree().change_scene_to_file(next_level_scene)
