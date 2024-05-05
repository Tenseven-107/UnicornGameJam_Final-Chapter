extends Node2D



# Objects
onready var collectible_handler: CollectibleHandler = $CollectibleHandler

# Items
onready var scrap_counter: Label = $CanvasLayer/Control/Control/VBoxContainer/ScrapCounter
onready var restart: Button = $CanvasLayer/Control/Control/VBoxContainer/Buttons/VBoxContainer/Restart
onready var quit: Button = $CanvasLayer/Control/Control/VBoxContainer/Buttons/VBoxContainer/Quit


# Variables
export (String, FILE, "*.tscn") var restart_scene: String = "res://Scenes/Main/Levels/Start.tscn"


# Set up
func _ready():
	scrap_counter.text = "You collected " + str(collectible_handler.get_collectible_amount()) + " scraps !"
	collectible_handler.clear_file()

	restart.connect("button_down", self, "restart_game")
	quit.connect("button_down", get_tree(), "quit")

	restart.grab_focus()


# Restart game
func restart_game():
	get_tree().change_scene(restart_scene)
