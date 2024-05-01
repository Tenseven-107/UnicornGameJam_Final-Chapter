extends Area2D
class_name Entity

# Signals
signal dead
signal update_hp(hp, max_hp)


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
export (Array, NodePath) var effects_heal
export (Array, NodePath) var effects_death

# Inactivity
export var _c_inactivity: String

export (Array, NodePath) var activity_objects_paths: Array
var activity_objects: Array

export (NodePath) var inactive_timer_path: NodePath
var inactive_timer: Timer
export (float) var inactive_time: float = 1
export (String) var activity_bool: String = "active"

# group
const group_name: String = "Entity"



# Setup
func _ready():
	add_to_group(group_name)
	current_hp = hp

	# Setting up physics layers
	collision_layer = LAYER
	collision_mask = MASK

	# Set i-frame timer
	if i_timer_path != "":
		i_timer = get_node(i_timer_path)
		i_timer.one_shot = true
		i_timer.wait_time = i_frames

	# Set up inactive timer
	if inactive_timer_path != "":
		for object in activity_objects_paths:
			activity_objects.append(get_node(object))

		inactive_timer = get_node(inactive_timer_path)
		inactive_timer.one_shot = true
		inactive_timer.wait_time = inactive_time
		inactive_timer.connect("timeout", self, "set_active")



# Damage/ healing handling
func handle_hit(hit_team: int, damage: int):
	if hit_team != team and current_hp > 0 and ((is_instance_valid(i_timer) and i_timer.is_stopped()) 
	or is_instance_valid(i_timer) == false):
		if invincible == false and GODMODE == false:
			current_hp -= damage

			if is_instance_valid(i_timer): i_timer.start()
			if is_instance_valid(inactive_timer): 
				for object in activity_objects: object.set(activity_bool, false)
				inactive_timer.start()

			if current_hp <= 0:
				die()

			# Emit a signal when hit
			emit_signal("update_hp", current_hp, hp)

			# Play effects on hit
			for effect in effects_hit:
				var play_effect: EffectPlayer = get_node(effect)
				play_effect.play_effect()


func handle_heal(hit_team: int, healed_hp: int):
	if hit_team == team:
		current_hp += healed_hp
		current_hp = clamp(current_hp, 0, hp)

		# Emit a signal when healed
		emit_signal("update_hp", current_hp, hp)

		# Play effects on heal
		for effect in effects_heal:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()



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



# Setting active again
func set_active():
	for object in activity_objects: object.set(activity_bool, true)









