extends Area2D
class_name Entity

# Signals
signal dead


# Objects
export (NodePath) var destroy_path: NodePath


# Damage handling variables
export var _c_hitpoints: String
var current_hp: int = 0
export (int) var hp: int = 5

export (bool) var invincible: bool = false
export (bool) var GODMODE: bool = false

export (int) var team: int = 0
export (bool) var destroy_on_death: bool = false

# Physics layers
const LAYER: int = 4
const MASK: int = 4



# Setup
func _ready():
	current_hp = hp

	# Setting up physics layers
	collision_layer = LAYER
	collision_mask = MASK



# Damage/ healing handling
func handle_hit(hit_team: int, damage: int):
	if hit_team != team:
		if invincible == false and GODMODE == false:
			current_hp -= damage

			if current_hp <= 0:
				die()


func handle_heal(hit_team: int, healed_hp: int):
	pass



# Death
func die():
	emit_signal("dead")

	if destroy_on_death == true:
		var destroy_object: Node = get_node(destroy_path)
		call_deferred("queue_free", destroy_object)


# Getting hp
func get_hp():
	return current_hp

func get_max_hp():
	return hp






