extends Node



# Objects
export var _c_objects: String

onready var tween: Tween = $Tween
onready var timer: Timer = $Timer
onready var start_timer: Timer = $StartTimer

export (NodePath) var screen_path: NodePath
onready var screen: ColorRect = get_node(screen_path)

var can_reset: bool = true

# At startup
export var _c_startup_effect: String

export (Color) var start_color: Color = Color.black
export (Color) var start_out_color: Color = Color(0,0,0,0)
export (float) var time_load: float = 1
export (float) var start_time: float = 1



# Set up
func _ready():
	GlobalSignals.connect("screen_effect", self, "effect")
	timer.connect("timeout", self, "reset")

	# Set up start
	start_timer.wait_time = start_time
	start_timer.one_shot = true
	start_timer.connect("timeout", self, "start_animation")

	screen.color = start_color
	screen.visible = true

	start_timer.start()


# Start animation
func start_animation(): effect(start_color, start_out_color, time_load, true)



# Functions
func effect(in_color: Color, out_color: Color, time: float, resets: bool):
	screen.visible = true
	can_reset = resets

	tween.interpolate_property(screen, "color", in_color, out_color, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	timer.wait_time = time
	timer.start()


# Reset
func reset():
	if can_reset == true: screen.visible = false
