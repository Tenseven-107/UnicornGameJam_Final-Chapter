extends Area2D
class_name Hitbox


# Objects
export (NodePath) var destroy_path: NodePath

# Damage
export (int) var damage: int = 1
export (int) var team: int = 0

export (bool) var active: bool = true

# Physics layers
const LAYER: int = 4
const MASK: int = 4


# Set up
func _ready():
	collision_layer = LAYER
	collision_mask = MASK



# Check for hits
func _process(delta):
	if active == true: check_hit()



# Check for hits
func check_hit():
	var overlapping_areas: Array = get_overlapping_areas()
	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if area.is_in_group(Entity.group_name):
				area.handle_hit(team, damage)

				if destroy_path != "" and area.invincible == false and area.team != team:
					get_node(destroy_path).call_deferred("queue_free")
