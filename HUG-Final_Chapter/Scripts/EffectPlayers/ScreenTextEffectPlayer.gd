extends EffectPlayer


export (String, MULTILINE) var text: String = "help"
export (Color) var text_color: Color = Color.white
export (float) var time: float = 1



func play_effect():
	GlobalSignals.emit_signal("text_effect", text, text_color, time)
