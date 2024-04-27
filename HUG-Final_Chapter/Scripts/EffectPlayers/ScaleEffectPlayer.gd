extends EffectPlayer


var tween: Tween

# Stats
export (NodePath) var object_path: NodePath

export (float) var duration: float = 1
export (Vector2) var start_scale: Vector2 = Vector2.ONE
export (Vector2) var end_scale: Vector2 = Vector2.ZERO

enum EASETYPE {
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT,
	EASE_OUT_IN
}
export (EASETYPE) var ease_type: int = 0

enum TRANSITIONTYPE {
	LINEAR,
	SINE,
	QUINT,
	QUART,
	QUAD,
	EXPO,
	ELASTIC,
	CUBIC,
	CIRC,
	BOUNCE,
	BACK
}
export (TRANSITIONTYPE) var transition_type: int = 0


# Play effect
func play_effect():
	var object: Node = get_node(object_path)

	if is_instance_valid(tween) == false:
		tween = Tween.new()
		add_child(tween)

	tween.interpolate_property(object, "scale", start_scale, end_scale, duration,
	transition_type, ease_type)

	tween.start()

