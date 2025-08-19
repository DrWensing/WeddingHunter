extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionPolygon2D.disabled = true
	hide()
	
func appear():
	$CollisionPolygon2D.disabled = false
	show()




