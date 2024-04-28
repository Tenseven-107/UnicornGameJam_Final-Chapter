extends CanvasLayer


# Objects
export (NodePath) var player_path: NodePath
var player: PlayerController

# Hud objects
onready var stamina_bar: TextureProgress = $Control/HBoxContainer/Left/PlayerStats/VBoxContainer/StaminaBar



# Setup
func _ready():
	player = get_node(player_path)

	stamina_bar.max_value = player.get_max_stamina()
	stamina_bar.value = player.get_stamina()


func _process(delta):
	set_stamina()



func set_stamina():
	stamina_bar.value = player.get_stamina()
