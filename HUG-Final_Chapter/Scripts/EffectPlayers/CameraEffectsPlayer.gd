extends EffectPlayer


# - Camera shake
export var _c_screenshake: String
export (bool) var camera_shake: bool = true
export (int) var new_cam_shake: int = 50
export (int) var cam_shake_limit: int = 500
export (float) var cam_shake_time: float = 0.05

# - Camera zoom
export var _c_camera_zoom: String
export (bool) var zoom: bool = false
export (float) var new_cam_zoom: float = 1
export (float) var cam_zoom_limit: float = 1
export (float) var cam_zoom_time: float = 0.07

# - Hitstop
export var _c_hitstop: String
export (bool) var hitstop: bool = false
export (float) var hitstop_time: float = 0.07



# Play effect
func play_effect():
	if camera_shake == true:
		GlobalSignals.emit_signal("camera_shake", new_cam_shake, cam_shake_time, cam_shake_limit)
	if zoom == true:
		GlobalSignals.emit_signal("camera_zoom", new_cam_zoom, cam_zoom_time, cam_zoom_limit)
	if hitstop == true:
		GlobalSignals.emit_signal("hitstop", hitstop_time)
