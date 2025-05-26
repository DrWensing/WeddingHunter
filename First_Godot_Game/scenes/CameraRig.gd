extends Node2D

@onready var player1 = %Player
@onready var player2 = %Player2
@export var camera: NodePath

@export var min_zoom: Vector2 = Vector2(1, 1)
@export var max_zoom: Vector2 = Vector2(2, 2)
@export var zoom_margin: float = 200.0

func _process(delta):
	var p1 = player1.global_position
	var p2 = player2.global_position

	# Move camera to midpoint
	global_position = (p1 + p2) / 2

	# Calculate required zoom based on distance between players
	var dist = (p1 - p2).abs()
	var viewport_size = get_viewport().size
	var zoom_x = (dist.x + zoom_margin) / viewport_size.x
	var zoom_y = (dist.y + zoom_margin) / viewport_size.y	
	var target_zoom = max(zoom_x, zoom_y)
	print(target_zoom)

	# Clamp zoom level
	
	#limit target_zoom between minimum and maximum 
	var zoom_val = clamp(target_zoom, min_zoom.x, max_zoom.x)
	zoom = Vector2.ONE * zoom_val
