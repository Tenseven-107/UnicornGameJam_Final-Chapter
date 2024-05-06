extends VisibilityNotifier2D
class_name VisibilityOptimizer


# Paths
export (NodePath) var visibility_path: NodePath
var visibility_object: Node2D

export (Array, NodePath) var processing_nodes: Array

# Disable timer
var disable_timer: Timer
const disable_time: float = 0.5



# Set up
func _ready():
	visibility_object = get_node(visibility_path)
	visibility_object.hide()

	self.connect("screen_entered", self, "enable")
	self.connect("screen_exited", self, "disable")

	# Set a timer to disable the nodes starting processes
	if processing_nodes.empty() == false:
		var new_timer = Timer.new()
		new_timer.one_shot = true
		new_timer.wait_time = disable_time

		disable_timer = new_timer
		add_child(new_timer)

		disable_timer.start()
		disable_timer.connect("timeout", self, "disable_timeout")

# Disable on timeout of the disable timer
func disable_timeout(): set_node_processes(false)



# Enable/ disable
func enable():
	visibility_object.show()
	set_node_processes(true)

func disable():
	visibility_object.show()
	set_node_processes(false)



# Set the processing of nodes
func set_node_processes(processing: bool):
	for path in processing_nodes:
		var node = get_node(path)
		node.set_process(processing)
		node.set_physics_process(processing)







