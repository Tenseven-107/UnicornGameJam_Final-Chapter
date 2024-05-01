extends EffectPlayer


# Stats
export (PackedScene) var spawned_effect: PackedScene
export (NodePath) var position_object: NodePath
export (bool) var should_inherit_rotation: bool = false

# Objects
export (String) var container_group: String = "FXContainer"
var fx_container: NodeContainer = null



# Play the effect
func play_effect():
	if is_instance_valid(fx_container) == false:
		get_container()

	var instance = spawned_effect.instance()
	var spawn_pos: Vector2 = get_node(position_object).global_position

	instance.global_position = spawn_pos
	if should_inherit_rotation == true:
		var spawn_rot = get_node(position_object).rotation
		instance.global_rotation = spawn_rot

	fx_container.call_deferred("add_child", instance)



# Get FX container in scene
func get_container():
	var containers = get_tree().get_nodes_in_group(container_group)
	fx_container = containers[0]


