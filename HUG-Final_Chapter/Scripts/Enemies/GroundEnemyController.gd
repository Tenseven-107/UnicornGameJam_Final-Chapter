extends KinematicBody2D
class_name GroundEnemyController



# Objects
export var _c_objects: String

export (NodePath) var right_ray_path: NodePath
onready var right_ray: RayCast2D = get_node(right_ray_path)

export (NodePath) var left_ray_path: NodePath
onready var left_ray: RayCast2D = get_node(left_ray_path)


export var _c_aditional_objects: String
export (NodePath) var detection_path: NodePath
var detection: RayCast2D
export (String) var detection_group: String = "Player"

export (NodePath) var body_path: NodePath
var body: Node2D


# Movement stats
export var _c_movement: String
export (float) var movement_speed: float = 25
export (float) var gravity: float = 10
var right_direction: bool = false

var velocity: Vector2 = Vector2.ZERO
onready var start_pos: Vector2 = global_position

var active: bool = true


# Settings for level editing
export var _c_enemy_settings_for_level: String
export (bool) var starts_right: bool = false
export (float) var turn_distance: float = 100


# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_turn
export (Array, NodePath) var effects_detect



# Setup
func _ready():
	active = true
	right_direction = starts_right

	if detection_path != "":
		detection = get_node(detection_path)

	if body_path != "":
		body = get_node(body_path)

		if right_direction == true: body.scale.x = 1
		else: body.scale.x = -1



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










