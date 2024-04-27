extends Node
class_name EffectPlayer


# On start variable
export (bool) var on_start: bool = false


# If on start is true, play effect when instantiated
func _ready():
	if on_start == true:
		play_effect()


# Play effect
func play_effect() -> void:
	return
