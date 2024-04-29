extends KinematicBody2D
class_name PlayerDroneController



# Objects
export var _c_objects: String
export (NodePath) var teleport_ray_path: NodePath
onready var teleport_ray: RayCast2D = get_node(teleport_ray_path)

export (NodePath) var body_path: NodePath
onready var body: Node2D = get_node(body_path)

export (NodePath) var shooter_path: NodePath
onready var shooter: BulletShooter = get_node(shooter_path)


# Movement stats
export var _c_movement: String
export (float) var max_speed: float = 180
export (float) var acceleration: float = 30
var current_speed: float = 0

# Teleport
export var _c_teleport: String
export (Vector2) var teleport_offset: Vector2 = Vector2(0, 10)
export (Vector2) var start_offset: Vector2 = Vector2(30, 0)

# Vectors
var input_vector: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# Misc
const group_name: String = "Drone"

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_shoot



# Setup
func _ready():
	add_to_group(group_name)

	teleport_ray.cast_to = teleport_offset * 2
	global_position = global_position + start_offset



# Processing
func _physics_process(delta):
	movement(delta)

func _process(delta):
	attacking()



# movement
func movement(delta):
	input_vector = get_move_input()

	if input_vector != Vector2.ZERO:
		current_speed += acceleration
		current_speed = clamp(current_speed, 0, max_speed)

		# Rotating to direction
		body.rotation = input_vector.angle()
	else: current_speed = 0

	velocity = move_and_slide(input_vector * current_speed) * delta

	# Wrap movement
	var viewport_trans = get_viewport_transform()
	var viewport_pos = viewport_trans.xform(global_position)
	var viewport_end = get_viewport().size
	viewport_pos.x = clamp(viewport_pos.x, 0, viewport_end.x)
	viewport_pos.y = clamp(viewport_pos.y, 0, viewport_end.y)
	global_position = viewport_trans.affine_inverse().xform(viewport_pos)



# Attacking
func attacking():
	if get_action_input() == true:
		shooter.play_effect()

		# Play effects on shoot
		for effect in effects_shoot:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()



# Getting the input depending on controller
func get_action_input():
	if Input.get_connected_joypads().size() > 1:
		if Input.is_action_just_pressed("action_drone2"):
			return true
	else:
		if Input.is_action_just_pressed("action_drone"):
			return true

	return false

func get_move_input():
	var inputs: Vector2 = Vector2.ZERO
	if Input.get_connected_joypads().size() > 1:
		inputs.x = Input.get_axis("left_drone2", "right_drone2")
		inputs.y = Input.get_axis("up_drone2", "down_drone2")

	else:
		inputs.x = Input.get_axis("left_drone", "right_drone")
		inputs.y = Input.get_axis("up_drone", "down_drone")

	return inputs



# Returns the position for the teleport ability
func get_teleport_pos():
	return global_position + teleport_offset

func check_can_teleport():
	if teleport_ray.is_colliding() == false:
		return true
	else: return false















