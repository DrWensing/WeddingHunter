extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
@onready var score_label = $ScoreLabel
@onready var message = $Message
@onready var message_timer = $MessageTimer
@onready var ammo_henrik = $ammo_henrik
@onready var ammo_tabea = $ammo_tabea

func set_ammo_henrik(ammo):
	ammo_henrik.frame = ammo
	
func set_ammo_tabea(ammo):
	ammo_tabea.frame = ammo
	
func get_ammo_henrik():
	return ammo_henrik.frame
	
func get_ammo_tabea():
	return ammo_tabea.frame

func update_score_label(score):
	#sets the score at the top of the screen
	score_label.text = "Score: " + str(score)
	
func show_message(text, delaytime = 2):
	#delaytime is an optional parameter in [s]
	$Message.text = text
	$Message.show()
	$MessageTimer.wait_time = delaytime
	$MessageTimer.start()
		
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func _on_message_timer_timeout():
	$Message.hide()
	$Message.text=""

# Called when the node enters the scene tree for the first time.
func _ready():
	show_message("Tabea und Henrik sind in den Flitterwochen...im Wald. Plötzlich gibt der Wagen den Geist auf. Sie sind auf sich gestellt...", 5.0)




