extends Node



# Objects
export var _c_objects: String

onready var tween: Tween = $Tween
onready var timer: Timer = $Timer
onready var text_timer: Timer = $TextTimer
onready var start_timer: Timer = $StartTimer

export (NodePath) var screen_path: NodePath
onready var screen: ColorRect = get_node(screen_path)

export (NodePath) var text_path: NodePath
onready var text: Label = get_node(text_path)

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
	GlobalSignals.connect("text_effect", self, "text_effect")

	timer.connect("timeout", self, "reset_flash")
	text_timer.connect("timeout", self, "reset_text")

	text.text = ""

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
func text_effect(new_text: String, text_color: Color, time: float):
	text.text = new_text
	text.add_color_override("font_color", text_color)

	text_timer.wait_time = time
	text_timer.start()


func effect(in_color: Color, out_color: Color, time: float, resets: bool):
	screen.visible = true
	can_reset = resets

	tween.interpolate_property(screen, "color", in_color, out_color, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	timer.wait_time = time
	timer.start()


# Reset flash
func reset_flash():
	if can_reset == true: screen.visible = false


# Reset text
func reset_text():
	text.text = ""






