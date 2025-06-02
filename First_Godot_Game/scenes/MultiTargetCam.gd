extends Camera2D

@export var move_speed = 0.25  # camera position lerp speed
@export var zoom_speed = 0.125  # camera zoom lerp speed
@export var min_zoom = 2  # camera won't zoom closer than this
@export var max_zoom = 5  # camera won't zoom farther than this
@export var margin = Vector2(400, 200)  # include some buffer area around targets

@onready var targets = []  # Array of targets to be tracked.

@onready var screen_size = get_viewport_rect().size

const y_offset = -20

func reset():
	targets = []

func _process(delta):
	if !targets:
		return
	# Keep the camera centered between the targets
	var p = Vector2.ZERO
	
	for target in targets:
		#remove targets, must be done once a new level loads
		if not is_instance_valid(target):
			remove_target(target)
			return
		#compute the average position
		p += target.global_position 		
	p /= targets.size()
	position = lerp(position, p, move_speed)
	position[1]+=y_offset
	# Find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)	
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)

func add_target(t):
	if not t in targets:
		print('appended to camera: ',t)
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)
		
func manual_set(position_vector, zoom_factor):
	self.position = lerp(self.position, position_vector, move_speed)
	self.zoom = lerp(zoom, zoom_factor, zoom_speed)
	
