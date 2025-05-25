extends Node2D

@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var game_manager = %GameManager

func _ready():
	interaction_area.interact = Callable(self, "_read")

func _read():
	InteractionManager.unregister_area(interaction_area)
	interaction_area.can_interact = false
	game_manager.show_message("Achtung: gefährliche Monster. Ohne Waffen habt ihr keine Chance.")
