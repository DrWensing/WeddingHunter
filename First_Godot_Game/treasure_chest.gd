extends Node2D

@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var game_manager = %GameManager

func _ready():
	interaction_area.interact = Callable(self, "_open_chest")

func _open_chest():
	animated_sprite_2d.frame = 1
	InteractionManager.unregister_area(interaction_area)
	interaction_area.can_interact = false
	game_manager._players_receive_guns()
