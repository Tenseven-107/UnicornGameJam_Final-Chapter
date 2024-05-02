extends KinematicBody2D
class_name GroundEnemyController



# Objects
export var _c_objects: String

export (NodePath) var right_ray_path: NodePath
onready var right_ray: RayCast2D = get_node(right_ray_path)

export (NodePath) var left_ray_path: NodePath
onready var left_ray: RayCast2D = get_node(left_ray_path)

export (NodePath) var entity_path: NodePath
onready var entity: Entity = get_node(entity_path)


# Additional objects
export var _c_aditional_objects: String
export (NodePath) var detection_path: NodePath
var detection: RayCast2D
export (String) var detection_group: String = "Player"

export (NodePath) var body_path: NodePath
var body: Node2D

# Actions
export (NodePath) var action_timer_path: NodePath
var action_timer: Timer

export (NodePath) var action_cooldown_timer_path: NodePath
var action_cooldown_timer: Timer

export (float) var action_time: float = 0.5
export (float) var action_cooldown: float = 0.5
export (bool) var unactive_before_action: bool = false


# Movement stats
export var _c_movement: String
export (float) var movement_speed: float = 25
export (float) var gravity: float = 10

var velocity: Vector2 = Vector2.ZERO
onready var start_pos: Vector2 = global_position

var right_direction: bool = false
var active: bool = true


# Settings for level editing
export var _c_enemy_settings_for_level: String
export (bool) var starts_right: bool = false
export (float) var turn_distance: float = 100


# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_turn
export (Array, NodePath) var effects_detect
export (Array, NodePath) var effects_action



# Setup
func _ready():
	active = true
	right_direction = starts_right

	# Aditional detection
	if detection_path != "":
		detection = get_node(detection_path)

	# Body
	if body_path != "":
		body = get_node(body_path)

		if right_direction == true: body.scale.x = 1
		else: body.scale.x = -1

	# Action timers
	if action_timer_path != "":
		action_timer = get_node(action_timer_path)

		action_timer.one_shot = true
		action_timer.wait_time = action_time

		action_timer.connect("timeout", self, "action")

	if action_cooldown_timer_path != "":
		action_cooldown_timer = get_node(action_cooldown_timer_path)

		action_cooldown_timer.one_shot = true
		action_cooldown_timer.wait_time = action_cooldown

		action_cooldown_timer.connect("timeout", self, "reactivate_action")



# processing
func _physics_process(delta):
	if active == true: movement(delta)
	turn_detect()

	if is_instance_valid(detection):
		aditional_detect()



# movement
func movement(delta):
	if right_direction == true: velocity.x = movement_speed
	else: velocity.x = -movement_speed

	velocity.y = gravity

	velocity = move_and_slide(velocity, Vector2.UP) * delta



# Function that detects if it should turn around
func turn_detect():
	if global_position.distance_to(start_pos) >= turn_distance or right_ray.is_colliding() or left_ray.is_colliding():
		right_direction = !right_direction

		right_ray.enabled = right_direction
		left_ray.enabled = !right_direction

		# Invert body
		if is_instance_valid(body):
			if right_direction == true: body.scale.x = 1
			else: body.scale.x = -1

		# Play effects on turn
		for effect in effects_turn:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()



# Aditional detection
func aditional_detect():
	if detection.is_colliding() and detection.get_collider().is_in_group(detection_group):
		# Play effects on detect
		for effect in effects_detect:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

		# Start action if there is a timer
		if is_instance_valid(action_timer) == true:
			if (action_timer.is_stopped() == true and 
			(is_instance_valid(action_cooldown_timer) == false or 
			(is_instance_valid(action_cooldown_timer) == true and action_cooldown_timer.is_stopped()))):

				action_timer.start()

				if unactive_before_action == true: active = false



# Do action
func action():
	reactivate_action()

	# Play effects on action
	for effect in effects_action:
		var play_effect: EffectPlayer = get_node(effect)
		play_effect.play_effect()

	if is_instance_valid(action_cooldown_timer) == true: action_cooldown_timer.start()



# Reactivate after action
func reactivate_action():
	if (unactive_before_action == true and (detection.is_colliding() == false or (detection.is_colliding() == true and 
	detection.get_collider().is_in_group(detection_group) == false))): 
		active = true



# Getting the entity
func get_entity():
	return entity








