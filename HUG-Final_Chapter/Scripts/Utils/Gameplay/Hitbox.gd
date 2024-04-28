extends Area2D
class_name Hitbox


# Objects
export (NodePath) var destroy_path: NodePath

# Damage
export (int) var damage: int = 1
export (int) var team: int = 0

# Physics layers
const LAYER: int = 4
const MASK: int = 4


func _ready():
	collision_layer = LAYER
	collision_mask = MASK


func _process(delta):
	var overlapping_areas: Array = get_overlapping_areas()
	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if area is Entity:
				area.handle_hit(team, damage)

				if destroy_path != "":
					get_node(destroy_path).call_deferred("queue_free")
