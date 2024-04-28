extends Area2D
class_name Entity

# Signals
signal dead


# Objects
export (NodePath) var destroy_path: NodePath

export (NodePath) var i_timer_path: NodePath
var i_timer: Timer


# Damage handling variables
export var _c_hitpoints: String
var current_hp: int = 0
export (int) var hp: int = 5
export (float) var i_frames: float = 1

export (bool) var invincible: bool = false
export (bool) var GODMODE: bool = false

export (int) var team: int = 0
export (bool) var destroy_on_death: bool = false

# Physics layers
const LAYER: int = 4
const MASK: int = 4

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_hit
export (Array, NodePath) var effects_death



# Setup
func _ready():
	current_hp = hp

	# Setting up physics layers
	collision_layer = LAYER
	collision_mask = MASK

	# Set i-frame timer
	if i_timer_path != "":
		i_timer = get_node(i_timer_path)
		i_timer.one_shot = true
		i_timer.wait_time = i_frames



# Damage/ healing handling
func handle_hit(hit_team: int, damage: int):
	if hit_team != team and current_hp > 0 and ((is_instance_valid(i_timer) and i_timer.is_stopped()) 
	or is_instance_valid(i_timer) == false):
		if invincible == false and GODMODE == false:
			current_hp -= damage

			if is_instance_valid(i_timer): i_timer.start()

			if current_hp <= 0:
				die()

			# Play effects on hit
			for effect in effects_hit:
				var play_effect: EffectPlayer = get_node(effect)
				play_effect.play_effect()


func handle_heal(hit_team: int, healed_hp: int):
	if hit_team == team:
		if (healed_hp + current_hp) <= hp:
			current_hp += healed_hp

		else:
			current_hp += (hp - healed_hp)



# Death
func die():
	emit_signal("dead")

	# Play effects on death
	for effect in effects_death:
		var play_effect: EffectPlayer = get_node(effect)
		play_effect.play_effect()

	if destroy_on_death == true:
		var destroy_object: Node = get_node(destroy_path)
		destroy_object.call_deferred("queue_free")


# Getting hp
func get_hp():
	return current_hp

func get_max_hp():
	return hp






