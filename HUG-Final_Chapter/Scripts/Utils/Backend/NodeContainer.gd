extends Node2D
class_name NodeContainer


export (String) var group_name: String = "Container"

# Setup
func _ready():
	self.add_to_group(group_name)

	var others: Array = get_tree().get_nodes_in_group(group_name)
	if others.size() > 1:
		for container in others:
			if container != self:
				container.call_deferred("queue_free")
