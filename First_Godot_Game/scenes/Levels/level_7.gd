extends Node2D

var SCROLL_SPEED = 24

func _ready():	
	HUD.visible=0
	HUD.hide_all()
	HUD.hide()
	MultiTargetCam.free()
	
	
func _physics_process(delta):
	$Abspann_Label.position.y -= SCROLL_SPEED*delta
	$Logo_Label.position.y -= SCROLL_SPEED*delta

	for child in get_children():
		if child is Node2D:
			child.position.y -= SCROLL_SPEED * delta


func _on_audio_stream_player_2d_finished():
	#sobald das Lied zuende gespielt ist, schließe das Spiel
	get_tree().quit()
