extends StaticBody2D

@onready var game_manager = %GameManager
@onready var rain = $rain
@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_manager.weather == "rain":
		rain.emitting = 1
		position.x = player.position.x
		position.y = player.position.y - 150
	else:
		rain.emitting = 0
	pass
