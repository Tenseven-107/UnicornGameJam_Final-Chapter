extends EffectPlayer


var tween: Tween

# Stats
export (NodePath) var object_path: NodePath

export (float) var duration: float = 1
export (Color) var start_color: Color = Color.red
export (Color) var end_color: Color = Color.white

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


# Setup
func _ready():
	if self.on_start == true:
		var object: Node = get_node(object_path)
		object.modulate = start_color

# Play effect
func play_effect():
	var object: Node = get_node(object_path)

	if is_instance_valid(tween) == false:
		tween = Tween.new()
		add_child(tween)

	tween.interpolate_property(object, "modulate", start_color, end_color, duration,
	transition_type, ease_type)

	tween.start()
