extends Node

@onready var game = $".."
@onready var projectile_container:Node = %Projectiles
@onready var hud = %HUD

@onready var cam = %Main2D/MultiTargetCam

const LevelPath = "res://scenes/Levels/"

var current_level: Node = null

var score: int = 0

func add_point():
	score += 1
	hud.update_score_label(score)
	
#func add_projectile(projectile):
	#add projectile
	#print(projectile)
	#print(projectile_container)
	#projectile_container.add_child(projectile)
	#print(projectile_container.get_children())

func _ready():
	var starting_level = 1
	load_level(starting_level)

	
func load_level(level: int) -> void:
	# Remove the current level if it exists		
	
	if current_level:
		current_level.queue_free()
		current_level = null
		print('delete level, remove camera')
		
	# Instance the level scene and add it to the tree
	get_tree().change_scene_to_file(LevelPath + "level_" + str(level) +".tscn")
	hud = load("res://scenes/hud.tscn").instantiate()
	add_child(hud)
	
func switch_to_next_level():
		var current_scene = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene.to_int() + 1
		
		var next_level_scene = "level_"  + str(next_level_number) + ".tscn"
		print("Switch to level " + next_level_scene)
		
		load_level(next_level_number)
		
func players_receive_guns():
	var player = get_tree().current_scene.get_node("Player") 
	var player2 = get_tree().current_scene.get_node("Player2") 
	player.equip_gun()
	player2.equip_gun()
	
func show_message(str, time_delay):
	hud.show_message(str, time_delay)


