extends Node2D

@onready var player = %Player
@onready var player2 = %Player2
@onready var label = $Label

const base_text = "[E] "

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	if area not in active_areas:
		active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	print('Removing interaction area')
	if index != -1:
		active_areas.remove_at(index)

func _process(delta):
	#print(active_areas.size())
	if active_areas.size() >0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x/2
		label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1, area2):
	if area1 == area2:
		return 0
	else:
		var area1_to_player_1 = player.global_position.distance_to(area1.global_position)
		var area2_to_player_1 = player.global_position.distance_to(area2.global_position)
		var area1_to_player_2 = player2.global_position.distance_to(area1.global_position)
		var area2_to_player_2 = player2.global_position.distance_to(area2.global_position)

		return area1_to_player_1 < area2_to_player_1

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
