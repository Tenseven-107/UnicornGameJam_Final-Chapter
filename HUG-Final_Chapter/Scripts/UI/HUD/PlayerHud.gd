extends CanvasLayer


# Objects
var player: PlayerController

# Hud objects
onready var stamina_bar: TextureProgress = $Control/HBoxContainer/Left/PlayerStats/VBoxContainer/StaminaBar



# Setup
func _ready():
	var players: Array = get_tree().get_nodes_in_group(PlayerController.group_name)
	player = players[0]

	stamina_bar.max_value = player.get_max_stamina()
	stamina_bar.value = player.get_stamina()


func _process(delta):
	set_stamina()



func set_stamina():
	stamina_bar.value = player.get_stamina()
