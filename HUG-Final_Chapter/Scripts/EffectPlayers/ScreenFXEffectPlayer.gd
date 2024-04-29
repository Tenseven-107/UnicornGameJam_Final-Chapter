extends EffectPlayer


export (Color) var in_color: Color = Color.white
export (Color) var out_color: Color = Color(0,0,0,0)
export (float) var time: float = 1
export (bool) var resets: bool = true



func play_effect():
	GlobalSignals.emit_signal("screen_effect", in_color, out_color, time, resets)
