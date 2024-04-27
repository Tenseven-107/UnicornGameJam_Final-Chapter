extends EffectPlayer


# Stats
export (float) var vibration: float = 0.1 # Weak motor
export (float) var strong_vibration: float = 0.1 # Strong motor
export (float) var time: float = 0.1

export (int) var device: int = 0
export (bool) var can_vibrate: bool = true



# Play effect
func play_effect():
	var joysticks = Input.get_connected_joypads()

	if joysticks.size() > 0 and can_vibrate:
		Input.start_joy_vibration(0, vibration, strong_vibration, time)
