extends CharacterBody2D

const SPEED = 30
var direction = 1
@onready var alert = false
@onready var animation_sprite = $AnimatedSprite2D
@onready var alert_label = $AlertLabel
@onready var hp = 70
@onready var health_bar = $HealthBar

var registered_player = null
var on_cooldown=false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_sprite.play("idle")
	
	#set alert label to nothing
	alert_label.text = ""
	alert_label.hide()

func _on_alert_area_body_entered(body):
	if body.name.begins_with("Player"):
		registered_player = body
		alert = true
		animation_sprite.play("walk")
		alert_label.text = "?!"
		alert_label.show()
	

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if on_cooldown:
		return
		
	if registered_player:
		var distance_to_player = registered_player.position.x - self.position.x 
		if abs(distance_to_player)>30:
			animation_sprite.play("walk")
			#follow player
			if distance_to_player < 0:
				direction = -1
			else:
				direction = +1
				
			velocity.x = SPEED*direction
		else:
			animation_sprite.play("attack")
			velocity.x = 0
			#deal damage
			registered_player.take_damage(20)
			#knockback
			registered_player.position.x += direction*20
			
			#start timer until orc moves again
			var attack_timer: Timer = Timer.new()
			add_child(attack_timer)
			attack_timer.one_shot = true
			attack_timer.autostart = false
			attack_timer.wait_time = 1.0
			attack_timer.timeout.connect(_on_attack_timer_timeout)
			attack_timer.start()
			on_cooldown = true
		
	move_and_slide()

func _on_attack_timer_timeout():
	on_cooldown = false
	

func receive_damage(dmg):
	health_bar.take_dmg(dmg)
	if health_bar.is_dead():
		print('Enemy slain!')
		Main.add_point()
		queue_free()

func _on_hit_box_area_entered(area):
	if area.name == "Fireball" or area.name.begins_with("@Area2D"):
		receive_damage(area.dmg)
		area.free()
