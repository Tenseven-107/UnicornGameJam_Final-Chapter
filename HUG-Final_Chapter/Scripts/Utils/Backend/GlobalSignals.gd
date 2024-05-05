extends Node


# Camera fx
signal camera_shake(new_shake, shake_time, shake_limit)
signal camera_zoom(new_zoom, zoom_time, zoom_limit)
signal hitstop(time)

signal lock_camera(position)
signal unlock_camera

# Overlay FX
signal screen_effect(in_color, out_color, time, reset)
signal text_effect(text, text_color, time, big)

# Gameplay
signal heal_player(team, hp)
signal gameover

signal save_collectibles()


# Bools
var can_teleport: bool = true # Dirty fix
