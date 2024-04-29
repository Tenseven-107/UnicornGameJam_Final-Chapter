extends Node2D




# Set up
func _ready():
	set_ignore_collisions()



# Set all enemies to ignore eachothers collisions
func set_ignore_collisions():
	var players: Array = get_tree().get_nodes_in_group(PlayerController.group_name)
	var drones: Array = get_tree().get_nodes_in_group(PlayerDroneController.group_name)

	var enemies: Array = get_children()
	if enemies.size() > 0:
		for enemy in enemies:
			enemy.add_collision_exception_with(players[0])
			enemy.add_collision_exception_with(drones[0])
			for e in enemies:
				enemy.add_collision_exception_with(e)
