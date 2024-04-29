extends Node


# Camera fx
signal camera_shake(new_shake, shake_time, shake_limit)
signal camera_zoom(new_zoom, zoom_time, zoom_limit)
signal hitstop(time)

# Overlay FX
signal black_in(time)
signal black_out(time)
signal flash(time)
signal glitch(time)

# Gameplay
signal gameover
