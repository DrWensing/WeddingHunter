extends CharacterBody2D

const SPEED = 30
var direction = 1
@onready var alert = false
@onready var animation_sprite = $AnimatedSprite2D
@onready var alert_label = $AlertLabel
@onready var hp = 70
@onready var health_bar = $HealthBar

var registered_player = []
var on_cooldown=false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_sprite.play("idle")
	
	#set alert label to nothing
	alert_label.text = ""
	alert_label.hide()
	
	health_bar.initialize(hp)

func _on_alert_area_body_entered(body):
	if not alert:
		if body.name.begins_with("Player"):
			registered_player.append(body)
			alert = true
			animation_sprite.play("walk")
			alert_label.text = "?!"
			alert_label.show()
			$detect_sound.play()

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if on_cooldown:
		return
		
	if not registered_player.is_empty():
		var closest_player = get_closest_player()
		var x_distance_to_closest_player = closest_player.position.x - self.position.x 
		var y_distance_to_closest_player = closest_player.position.y - self.position.y + 110 #offset is a hotfix
		if abs(x_distance_to_closest_player)>40 or abs(y_distance_to_closest_player)>30:
			#print(x_distance_to_closest_player, y_distance_to_closest_player)
			animation_sprite.play("walk")
			#follow player
			if x_distance_to_closest_player < 0:
				direction = -1
				animation_sprite.flip_h = false
			else:
				direction = +1
				animation_sprite.flip_h = true
				
			velocity.x = SPEED*direction
		else:
			animation_sprite.play("attack")
			$attack_sound.play()
			velocity.x = 0
			#deal damage
			closest_player.take_damage(20)
			#knockback
			closest_player.position.x += direction*20
			
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

func get_closest_player():
	#only 1 player detected
	if registered_player.size()==1:
		return registered_player[0]
	
	#2 players:
	var dist0 = registered_player[0].position.x - self.position.x
	var dist1 = registered_player[1].position.x - self.position.x
	
	if abs(dist0) < abs(dist1):
		return registered_player[0]
	else:
		return registered_player[1]
	
func _on_attack_timer_timeout():
	on_cooldown = false	

func receive_damage(dmg):
	$hit_sound.play()
	health_bar.take_dmg(dmg)
	if health_bar.is_dead():
		Main.add_point()
		queue_free()

func _on_hit_box_area_entered(area):
	if area.name == "Fireball" or area.name.begins_with("@Area2D"):
		receive_damage(area.dmg)
		area.free()
