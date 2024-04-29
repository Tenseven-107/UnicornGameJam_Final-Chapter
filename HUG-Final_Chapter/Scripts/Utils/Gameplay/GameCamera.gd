extends Camera2D
class_name GameCamera



# Objects
onready var shake_timer = $Timer
onready var shake_tween = $Shake_tween
onready var zoom_tween = $Zoom_tween
onready var zoom_timer = $Timer2
onready var hitstop_tween = $Hitstop_tween
onready var hitstop_timer = $Timer3

# Stats
export (bool) var snappy_camera: bool = false

# - Settings
var can_zoom: bool = true
var shake_multiplier: float = 1

export (float) var x_cam_offset: float = 15
export (float) var y_cam_offset: float = 30
var last_cam_offset: Vector2

# Movement
export (NodePath) var target_path: NodePath
onready var player_target: PlayerController

# Cam effect variables
var shake_amount: float = 0
var normal_offset = offset
var zoom_amount: float = 0
var normal_zoom = zoom

var shaking: bool = false

# Misc
const cam_area_group: String = "CameraArea"
const group_name: String = "GameCamera"



# Set up
func _ready():
	add_to_group(group_name)

	visible = true
	shaking = false
	set_as_toplevel(true)

	GlobalSignals.connect("camera_shake", self, "shake")
	GlobalSignals.connect("camera_zoom", self, "zoom_cam")
	GlobalSignals.connect("hitstop", self, "time_stop")

	if target_path != "":
		player_target = get_node(target_path)


# Process

func _process(delta):
	if snappy_camera:
		var x = global_position.x
		var y = global_position.y
		global_position = Vector2(int(x), int(y))

		var offset_x = offset.x
		var offset_y = offset.y
		offset = Vector2(int(offset_x), int(offset_y))

	if shaking:
		offset = normal_offset - Vector2(rand_range(-shake_amount, shake_amount),
		rand_range(shake_amount, -shake_amount)) * delta

	if is_instance_valid(player_target):
		update_cam()


# Update camera
func update_cam():
	var player_offset = Vector2(player_target.input_vector.normalized().x * x_cam_offset, -y_cam_offset)
	if player_offset.x != 0 and player_target.input_vector.y == 0:
		last_cam_offset = player_offset

	global_position = lerp(global_position, player_target.global_position + last_cam_offset, 1)



# Camera shake
func shake(new_shake, shake_time, shake_limit):
	if shake_multiplier != 0:
		var fps = Engine.get_frames_per_second()
		if fps <= 60:
			new_shake /= 2
			shake_limit /= 2

		shaking = true
		shake_amount += new_shake * shake_multiplier
		if shake_amount > shake_limit:
			shake_amount = shake_limit

		shake_timer.wait_time = shake_time
		shake_tween.stop_all()
		shake_timer.start()


func _on_Timer_timeout():
	shake_amount = 0
	shaking = false

	shake_tween.interpolate_property(self, "offset", offset, normal_offset, 0.1, 
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	shake_tween.start()



# Camera zoom
func zoom_cam(new_zoom, zoom_time, zoom_limit):
	if can_zoom == true:
		zoom_amount -= new_zoom
		zoom_amount = clamp(zoom_amount, zoom_limit, 1)

		zoom = Vector2(zoom_amount, zoom_amount)

		zoom_timer.wait_time = zoom_time
		zoom_tween.stop_all()
		zoom_timer.start()


func _on_Timer2_timeout():
	shake_tween.interpolate_property(self, "zoom", zoom, normal_zoom, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	shake_tween.start()



# Hitstop
func time_stop(time):
	hitstop_tween.interpolate_property(Engine, "time_scale", 0.01, 1, time, Tween.TRANS_LINEAR)

	hitstop_timer.wait_time = time
	hitstop_timer.start()
	hitstop_tween.start()



func _on_Timer3_timeout():
	Engine.time_scale = 1



func initialize(player: Node):
	player_target = player






