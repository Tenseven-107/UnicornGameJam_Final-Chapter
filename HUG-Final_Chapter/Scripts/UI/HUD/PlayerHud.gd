extends CanvasLayer
class_name PlayerHud


# Hud objects
onready var stamina_bar: TextureProgress = $UI/HBoxContainer/Left/PlayerStats/VBoxContainer/StaminaBar

onready var empty_hp: TextureRect = $UI/HBoxContainer/Left/PlayerStats/VBoxContainer/HP/Empty
onready var full_hp: TextureRect = $UI/HBoxContainer/Left/PlayerStats/VBoxContainer/HP/Full
var hp_rect_size: float = 10

# Pause menu
onready var pause_menu = $Pause

onready var resume: Button = $Pause/Menu/Resume
onready var quit: Button = $Pause/Menu/Quit

onready var master_volume: Slider = $Pause/Menu/VolumeMaster/Volume
onready var music_volume: Slider = $Pause/Menu/VolumeMusic/Volume

onready var fullscreen: CheckBox = $Pause/Menu/full_screen

var is_paused: bool = false


# Set up
func _ready():
	# Set up pause
	pause_menu.hide()
	is_paused = false

	resume.connect("button_down", self, "pause")
	quit.connect("button_down", get_tree(), "quit")

	master_volume.value = AudioServer.get_bus_volume_db(0)
	music_volume.value = AudioServer.get_bus_volume_db(1)

	master_volume.connect("value_changed", self, "set_master")
	music_volume.connect("value_changed", self, "set_music")

	fullscreen.pressed = OS.window_fullscreen

	fullscreen.connect("toggled", self, "set_fullscreen")



# Setting menu items
func set_stamina(stamina: int, max_stamina: int):
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina


func set_hp(hp: int, max_hp: int):
	empty_hp.rect_size.x = hp_rect_size * max_hp
	full_hp.rect_size.x = hp_rect_size * hp

	if hp <= 0:
		full_hp.hide()
	else: full_hp.show()




# Input
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		pause()


# pause the game
func pause():
	if is_paused == false:
		get_tree().paused = true

		is_paused = true
		pause_menu.show()

		resume.grab_focus()


	else:
		get_tree().paused = false

		is_paused = false
		pause_menu.hide()



# Setting the volume
func set_master(volume: float): AudioServer.set_bus_volume_db(0, volume)

func set_music(volume: float): AudioServer.set_bus_volume_db(1, volume)


# Setting fullscreen
func set_fullscreen(toggle: bool): OS.window_fullscreen = toggle












