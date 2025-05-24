extends Node2D

@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	print("open chest")
