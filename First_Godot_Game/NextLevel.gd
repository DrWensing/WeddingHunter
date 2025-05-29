extends Area2D



func _on_body_entered(body):
	if body.name == "Player" or body.name == "Player2":
		var current_scene = get_tree().current_scene.scene_file_path
		print(current_scene)
		#var level2_scene = preload("res://scenes/Levels/level_2.tscn").instantiate()
		#print("Change level")
		#print("Switch to level 2")
		#get_tree().root.add_child(level2_scene)
