extends StaticBody2D
class_name EnemyDoor



# Objects
export (Array, NodePath) var enemy_door_paths: Array
var other_doors: Array

onready var area: Area2D = $ActivationArea
onready var collider: CollisionShape2D = $CollisionShape2D

# Enemies
export var _c_enemies: String

export (Array, NodePath) var enemy_paths: Array
var entities: Array

# Activity
var active: bool
var current_entities: int

# Settings 
export var _c_settings: String
export (bool) var from_right: bool = false

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_close
export (Array, NodePath) var effects_open



# Set up
func _ready():
	# set up variables
	collider.disabled = true
	active = true

	# Set up objects
	for enemy_door_path in enemy_door_paths:
		var door = get_node(enemy_door_path)
		if door.has_method("close"):
			other_doors.append(door)

	for enemy_path in enemy_paths:
		var enemy = get_node(enemy_path)
		if enemy.has_method("get_entity"):
			var entity: Entity = enemy.get_entity()
			entity.invincible = true
			entity.connect("dead", self, "complete")

			entities.append(entity)

	current_entities = entities.size()

	area.connect("body_exited", self, "check_close")



# Check if can close
func check_close(body: Node):
	if (body.is_in_group(PlayerController.group_name) and 
	((body.global_position.x < global_position.x and from_right == true) or
	(body.global_position.x > global_position.x and from_right == false))):
		close()



# Close door
func close():
	if active == true:
		collider.set_deferred("disabled", false)
		active = false

		# Play effects on close
		for effect in effects_close:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

		# close other doors
		for door in other_doors:
			door.close()

		# make enemies not invincible anymore
		for entity in entities:
			if entity.invincible == true:
				entity.invincible = false

			else: break


# Open door
func open():
	collider.set_deferred("disabled", true)

	# Play effects on open
	for effect in effects_open:
		var play_effect: EffectPlayer = get_node(effect)
		play_effect.play_effect()



# Check if all enemies are killed, and if so, open all the doors
func complete():
	if active == false:
		current_entities -= 1

		if current_entities <= 0:
			open()














