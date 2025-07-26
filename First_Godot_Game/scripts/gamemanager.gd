extends Node

@onready var game = $".."
@onready var projectile_container:Node = %Projectiles
@onready var hud = %HUD

@onready var cam = %Main2D/MultiTargetCam
@onready var timer = $Timer

const LevelPath = "res://scenes/Levels/"

var current_level: Node = null

var score: int = 0

func _ready():
	var starting_level = 4
	load_level(starting_level)
	hud.update_score_label(score)	
	
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
		
func add_point():
	set_score(score + 1)
	
func set_score(points):
	score = points
	hud.update_score_label(score)
	
func players_receive_guns():
	var player = get_tree().current_scene.get_node("Player") 
	var player2 = get_tree().current_scene.get_node("Player2") 
	player.equip_gun()
	player2.equip_gun()
	
func show_message(str, time_delay):
	hud.show_message(str, time_delay)
	
func player_died(body):
	set_score(0)

	Engine.time_scale = 0.5
	if body.get_node("CollisionShape2D") != null:
		body.get_node("CollisionShape2D").queue_free()	
	body.velocity.y = +100

	#launch timer
	var kill_timer: Timer = Timer.new()
	add_child(kill_timer)
	kill_timer.one_shot = true
	kill_timer.autostart = false
	kill_timer.wait_time = 1.0
	kill_timer.timeout.connect(_on_kill_timer_timeout)
	kill_timer.start()
	match body.name:
		'Player': 
			HUD.show_message("Game Over: Henrik wurde gekillt!")
		'Player2':
			HUD.show_message("Game Over: Tabea wurde gekillt!")
		'Dog':
			HUD.show_message("Game Over: Hermann wurde gekillt!")

func _on_kill_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	pass # Replace with function body.
	
func get_min_player_distance_to_node(p1,p2,node):
	#computes the minimum distance between players and a given node
	var p1_dist = p1.get_distance_to(node)
	var p2_dist = p2.get_distance_to(node)
	return min(p1_dist,p2_dist)
