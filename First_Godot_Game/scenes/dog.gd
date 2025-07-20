extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0
var direction = 0
var dist_p1 = 50
var dist_p2 = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = %Player
@onready var player2 = %Player2
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_pet_dog")
	
func die():
	Main.player_died(self)

func _pet_dog():
	print("Wuff wuff")
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if player.position.y < position.y - 10 and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	dist_p1 = (player.position.x - position.x)**2 + (player.position.y - position.y)**2
	dist_p2 = (player2.position.x - position.x)**2+ (player2.position.y- position.y)**2
	
	if abs(dist_p1) < abs(dist_p2):
		#Follow player 1
		if player.position.x > position.x + 30:
			direction = +1
			animated_sprite_2d.flip_h = true
		elif player.position.x < position.x - 30:
			direction = -1
			animated_sprite_2d.flip_h = false		
		else:
			direction = 0
	else:
		# Follow player 2
		if player2.position.x > position.x + 30:
			direction = +1
			animated_sprite_2d.flip_h = true
		elif player2.position.x < position.x - 30:
			direction = -1
			animated_sprite_2d.flip_h = false		
		else:
			direction = 0
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#Play animation
	if is_on_floor():
		animated_sprite_2d.play("default")
	else:
		animated_sprite_2d.play("jump")

	move_and_slide()
