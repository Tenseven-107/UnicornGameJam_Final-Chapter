extends CanvasLayer
class_name PlayerHud


# Hud objects
onready var stamina_bar: TextureProgress = $UI/HBoxContainer/Left/PlayerStats/VBoxContainer/StaminaBar

onready var empty_hp: TextureRect = $UI/HBoxContainer/Left/PlayerStats/VBoxContainer/HP/Empty
onready var full_hp: TextureRect = $UI/HBoxContainer/Left/PlayerStats/VBoxContainer/HP/Full
var hp_rect_size: float = 10



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










