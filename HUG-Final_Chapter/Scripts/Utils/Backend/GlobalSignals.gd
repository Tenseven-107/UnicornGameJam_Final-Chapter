extends Node


# Camera fx
signal camera_shake(new_shake, shake_time, shake_limit)
signal camera_zoom(new_zoom, zoom_time, zoom_limit)
signal hitstop(time)

# Overlay FX
signal screen_effect(in_color, out_color, time, reset)

# Gameplay
signal gameover
