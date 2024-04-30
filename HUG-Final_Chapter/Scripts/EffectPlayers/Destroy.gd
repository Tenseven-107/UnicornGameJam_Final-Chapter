extends EffectPlayer


# Objects
export (NodePath) var timer_path: NodePath
onready var timer: Timer

export (NodePath) var destroy_object_path: NodePath
onready var destroy_object: Node

# Stats
export (float) var stay_time: float = 1


# Play effect
func play_effect():
	if is_instance_valid(timer) == false:
		timer = get_node(timer_path)
	if is_instance_valid(destroy_object) == false:
		destroy_object = get_node(destroy_object_path)

	timer.wait_time = stay_time
	timer.one_shot = true

	timer.start()
	timer.connect("timeout", destroy_object, "queue_free")
