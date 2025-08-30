extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
@onready var score_label = $ScoreLabel
@onready var message = $Message
@onready var message_frame = $MessageFrame
@onready var message_timer = $MessageTimer
@onready var ammo_henrik = %ammo_henrik
@onready var ammo_tabea = %ammo_tabea

@onready var HP_bar_henrik = %HP_bar_henrik
@onready var HP_bar_tabea = %HP_bar_tabea
@onready var ingredients_collected = [0,0,0,0,0,0]



func set_hp_henrik(hp):
	HP_bar_henrik.value = hp
	
func set_hp_tabea(hp):
	HP_bar_tabea.value = hp

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
	$MessageFrame.show()
	$Message.text = text
	$Message.show()
	$MessageTimer.wait_time = delaytime
	$MessageTimer.start()
		
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func _on_message_timer_timeout():
	$Message.hide()
	$Message.text=""
	$MessageFrame.hide()
	
func update_ingredients():
	var gray  = Color(0.1, 0.1, 0.1)
	var white = Color(1, 1, 1)
	
	$dutch_ingredient.make_non_interactable()
	$dutch_ingredient2.make_non_interactable()
	$dutch_ingredient3.make_non_interactable()
	$dutch_ingredient4.make_non_interactable()
	$dutch_ingredient5.make_non_interactable()
	$dutch_ingredient6.make_non_interactable()
	
	print('ingredients_collected', ingredients_collected)
	#ingredient 1
	if ingredients_collected[0]:
		$dutch_ingredient.modulate = white
	else:
		$dutch_ingredient.modulate = gray
		
	#ingredient 2
	if ingredients_collected[1]:
		$dutch_ingredient2.modulate = white
	else:
		$dutch_ingredient2.modulate = gray
		
	#ingredient 3
	if ingredients_collected[2]:
		$dutch_ingredient3.modulate = white
	else:
		$dutch_ingredient3.modulate = gray
		
	#ingredient 4
	if ingredients_collected[3]:
		$dutch_ingredient4.modulate = white
	else:
		$dutch_ingredient4.modulate = gray
		
	#ingredient 5
	if ingredients_collected[4]:
		$dutch_ingredient5.modulate = white
	else:
		$dutch_ingredient5.modulate = gray
		
	#ingredient 6
	if ingredients_collected[5]:
		$dutch_ingredient6.modulate = white
	else:
		$dutch_ingredient6.modulate = gray

	
func _ready():
	$Message.hide()
	$Message.text=""
		
	$dutch_ingredient.sprite.frame = 0
	$dutch_ingredient2.sprite.frame = 1
	$dutch_ingredient3.sprite.frame = 2
	$dutch_ingredient4.sprite.frame = 3
	$dutch_ingredient5.sprite.frame = 4
	$dutch_ingredient6.sprite.frame = 5
		
	update_ingredients()


func hide_all():
	print('Hide all stuff')
	score_label.hide()
	HP_bar_henrik.hide()
	$Henrik.visible = false
	$Henrik.hide()
	$Tabea.hide()
	$Tabea.free()
	self.visible = false

func _process(delta):
	#if game is paused: show pause menu
	$PauseMenu.visible = get_tree().paused == true
	
