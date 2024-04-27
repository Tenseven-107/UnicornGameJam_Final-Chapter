extends KinematicBody2D
class_name PlayerController



# Objects
export var _c_objects: String
export (Array, NodePath) var raycasts: Array

export (NodePath) var coyote_timer_path: NodePath
onready var coyote_timer: Timer = get_node(coyote_timer_path)

# Movement
export var _c_movement: String
export (float) var move_speed: float = 16000

# Jumping
export var _c_jumping: String
export (float) var jump_force: float = 600
onready var coyote_jump_force: float = jump_force * 1.5
export (float) var coyote_time: float = 1

export (float) var gravity: float = 2100
export (float) var min_gravity: float = 200
var current_gravity: float
onready var gravity_depletion: float = (gravity - min_gravity) / 12
var is_jumping: bool = false
var coyote: bool = false

# Vectors
var x_input: float = 0
var y_input: float = 0
var velocity: Vector2 = Vector2.ZERO

# Attacking
var can_attack = true

# States
export var _c_states: String
enum STATES {
	ACTIVE,
	UNACTIVE,
	DEAD
}
export (int) var current_state: int = STATES.ACTIVE

# Switches
export var _c_switches: String
export (bool) var has_jump: bool = true
export (bool) var has_attack: bool = true
export (bool) var has_teleport: bool = true
export (bool) var has_charge: bool = true



# Set up
func _ready():
	# Jumping set up
	current_gravity = gravity
	is_jumping = false

	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true



# Processing
func _physics_process(delta):
	set_velocity(delta)

func _process(delta):
	run_states(delta)


# Running the states
func run_states(delta):
	match current_state:
		STATES.ACTIVE:
			movement(delta)
			jumping(delta)
			can_attack = true
		STATES.UNACTIVE:
			pass
		STATES.DEAD:
			pass

func switch_state(new_state: int):
	if new_state > STATES.size() - 1:
		current_state = STATES.ACTIVE

	else:
		current_state = new_state



# Movement
func movement(delta):
	x_input = Input.get_axis("left_player", "right_player")

func jumping(delta):
	# Initiating jump
	if Input.is_action_just_pressed("jump") and (check_rays() == true or coyote_timer.is_stopped() == false):
		is_jumping = true

		# Coyote jump
		if coyote_timer.is_stopped() == false and is_on_floor() == false and check_rays() == false:
			coyote = true

		coyote_timer.stop()

	# Jumping
	if Input.is_action_pressed("jump") and is_jumping == true:
		y_input = get_jump_force()

		if current_gravity > min_gravity:
			current_gravity -= gravity_depletion

	# Release jump
	if Input.is_action_just_released("jump") or current_gravity <= min_gravity:
		is_jumping = false
		current_gravity = gravity
		y_input = 0

func get_jump_force():
	return jump_force if coyote == false else coyote_jump_force



# Check is raycasts are colliding
func check_rays():
	for raycast in raycasts:
		var object: RayCast2D = get_node(raycast)
		if object.is_colliding():
			return true
	return false



# Setting the velocity
func set_velocity(delta):
	velocity.x = (x_input * move_speed) * delta
	velocity.y += current_gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_floor() or coyote == true:
		velocity.y -= y_input

		if is_jumping == false: coyote_timer.start()
		coyote = false






