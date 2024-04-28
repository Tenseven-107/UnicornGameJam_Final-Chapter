extends KinematicBody2D
class_name PlayerController



# Objects
# - Movement
export var _c_objects: String
export (Array, NodePath) var raycasts: Array

export (NodePath) var coyote_timer_path: NodePath
onready var coyote_timer: Timer = get_node(coyote_timer_path)

# - Visuals
export (NodePath) var sprite_path: NodePath
onready var sprite: AnimatedSprite = get_node(sprite_path)

# - Combat
export (NodePath) var attack_ray_path: NodePath
onready var attack_ray: RayCast2D = get_node(attack_ray_path)

export (NodePath) var attack_timer_path: NodePath
onready var attack_timer: Timer = get_node(attack_timer_path)

export (NodePath) var attack_cooldown_path: NodePath
onready var attack_cooldown: Timer = get_node(attack_cooldown_path)

# - Dodge roll
export (NodePath) var dodge_timer_path: NodePath
onready var dodge_timer: Timer = get_node(dodge_timer_path)

export (NodePath) var entity_path: NodePath
onready var entity: Entity = get_node(entity_path)


# Movement
export var _c_movement: String
export (float) var move_speed: float = 16000

# - Jumping
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
var last_x_input: float = 0
var x_input: float = 0
var y_input: float = 0
var velocity: Vector2 = Vector2.ZERO


# Attacking
export var _c_combat: String
export (float) var attack_ray_reach: float = 50
export (float) var attack_time: float = 0.1
export (float) var attack_cooldown_time: float = 0.2
onready var ATTACK_COOLDOWN: float = attack_time + attack_cooldown_time


# Dodging
export var _c_dodge_roll: String
export (float) var dodge_time: float = 0.36


# States
export var _c_states: String
enum STATES {
	ACTIVE,
	CHARGING,
	DEAD
}
export (STATES) var current_state: int = STATES.ACTIVE


# Switches
export var _c_switches: String
export (bool) var has_jump: bool = true
export (bool) var has_attack: bool = true
export (bool) var has_teleport: bool = true
export (bool) var has_charge: bool = true



# Set up
func _ready():
	# General setup
	sprite.flip_h = true
	x_input = 1
	last_x_input = x_input

	# Jumping set up
	current_gravity = gravity
	is_jumping = false

	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true

	# Combat
	attack_ray.cast_to.x = attack_ray_reach
	attack_ray.collide_with_bodies = false
	attack_ray.collide_with_areas = true
	attack_ray.add_exception(entity)

	attack_timer.wait_time = attack_time
	attack_timer.one_shot = true
	attack_cooldown.wait_time = ATTACK_COOLDOWN
	attack_cooldown.one_shot = true

	attack_timer.connect("timeout", self, "attack_recovery")

	# Dodge roll
	dodge_timer.wait_time = dodge_time
	dodge_timer.one_shot = true

	dodge_timer.connect("timeout", self, "finish_dodge")



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
			attacking()
			dodging()
		STATES.CHARGING:
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
	if attack_cooldown.is_stopped() and dodge_timer.is_stopped():
		x_input = Input.get_axis("left_player", "right_player")
	if x_input != 0:  last_x_input = x_input

	# Turning the players direction
	if x_input > 0: 
		sprite.flip_h = true
		attack_ray.cast_to.x = attack_ray_reach
	elif x_input < 0: 
		sprite.flip_h = false
		attack_ray.cast_to.x = -attack_ray_reach


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



# Combat
func attacking():
	if player_action("attack_player"):
		x_input = last_x_input

		attack_timer.start()
		attack_cooldown.start()

		if attack_ray.is_colliding():
			var colliding_entity = attack_ray.get_collider()

func attack_recovery():
	x_input = 0



# ROLLING ROLLING ROLLING ROLLING
func dodging():
	if player_action("action_player"):
		x_input = last_x_input

		entity.invincible = true
		dodge_timer.start()

func finish_dodge():
	x_input = 0
	entity.invincible = false



# Used to check if the player can do a certain action besides simply moving
func player_action(control_action: String):
	if (Input.is_action_just_pressed(control_action) and is_on_floor() and attack_cooldown.is_stopped() 
	and dodge_timer.is_stopped()):
		return true
	return false













