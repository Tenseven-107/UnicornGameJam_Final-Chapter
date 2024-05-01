extends Area2D




export (Array, String) var target_groups: Array

export (int) var hp: int = 1
export (int) var team: int = 0



# Set up
func _ready():
	self.connect("body_entered", self, "pickup")



# Pick up
func pickup(body: Node):
	for t_group in target_groups:
		if body.is_in_group(t_group):
			GlobalSignals.emit_signal("heal_player", team, hp)

			call_deferred("queue_free")
