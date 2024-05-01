extends Node2D



# Objects
onready var anims: AnimationPlayer = $Visuals/Anims

onready var timer: Timer = $Utility/Timer
onready var dissapear_timer: Timer = $Utility/DissapearTimer

onready var label: Label = $Visuals/Label


# Stats
export (String) var anim_name: String = "Intro"
export (float) var time: float = 43
export (float) var dissapear_time: float = 2
export (String, FILE, ".tscn") var next_scene: String = "res://Scenes/Testing/Testing.tscn"



# Set up
func _ready():
	anims.play("Intro")

	timer.connect("timeout", self, "goto_next_scene")
	timer.wait_time = time
	timer.one_shot = true
	timer.start()

	dissapear_timer.connect("timeout", label, "hide")
	dissapear_timer.wait_time = dissapear_time
	dissapear_timer.one_shot = true

	label.hide()



# Process input
func _unhandled_input(event):
	if event.is_pressed() and dissapear_timer.is_stopped() == false:
		goto_next_scene()

	if event.is_pressed():
		dissapear_timer.start()
		label.show()



# Go to next scene
func goto_next_scene():
	get_tree().change_scene(next_scene)













