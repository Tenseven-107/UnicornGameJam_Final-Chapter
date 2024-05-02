extends KinematicBody2D
class_name FlyingEnemyController



# Objects
onready var target_range: Area2D = $Range
onready var entity: Entity = $Combat/Entity


# Aditional objects
export var _c_additional_objects: String
export (NodePath) var body_path: NodePath
onready var body: Node2D = get_node(body_path)

export (NodePath) var rest_timer_path: NodePath
var rest_timer: Timer
export (float) var rest_time: float = 4


# Sine movement
export var _c_sine_speed: String
var time: float
export (float) var frequency: float = 4

# Combat
export var _c_combat: String
export (bool) var invincible_on_idle: bool = true

# Movement
export var _c_movement: String
export (float) var speed: float = 120
export (float) var min_speed: float = 50
var current_speed: float = 0

export (float) var distance: float = 4
var velocity = Vector2.ZERO
var last_pos = Vector2.ZERO

var active: bool = true

var target = null
var detected: bool = false

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_action
export (Array, NodePath) var effects_detect
export (Array, NodePath) var effects_lost




# setup
func _ready():
	detected = false
	active = true

	if invincible_on_idle == true: entity.invincible = true

	target_range.connect("body_entered", self, "get_target")
	target_range.connect("body_exited", self, "reset_target")

	if rest_timer_path != "":
		rest_timer = get_node(rest_timer_path)
		rest_timer.one_shot = true
		rest_timer.wait_time = rest_time

		rest_timer.connect("timeout", self, "action")

	if body_path != "":
		body = get_node(body_path)



# Processing
func _physics_process(delta):
	if active == true:
		if global_position.distance_to(last_pos) > distance and detected == true:
			time += delta
			current_speed = sin(time * frequency) * speed
			current_speed = clamp(current_speed, min_speed, speed)

			if time > 1: time = 0

			velocity -= (global_position - last_pos).normalized() * current_speed
			velocity = move_and_slide(velocity) * delta

	if is_instance_valid(target) == true:
		last_pos = target.global_position

		if is_instance_valid(body) == true:
			if target.global_position.x > global_position.x: body.scale.x = -1
			elif target.global_position.x < global_position.x: body.scale.x = 1



# Targeting
func get_target(body: Node):
	if body.is_in_group(PlayerController.group_name):
		target = body
		detected = true

		if invincible_on_idle == true: entity.invincible = false

		# Play effects on detect
		for effect in effects_detect:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

func reset_target(body: Node):
	if body.is_in_group(PlayerController.group_name) and target == body:
		target = null

		if invincible_on_idle == true: entity.invincible = true

		# Play effects on lost
		for effect in effects_lost:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()



# action when rest time is over
func action():
	if is_instance_valid(target):
		rest_timer.start()

		# Play effects on action
		for effect in effects_action:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()




# Getting the entity
func get_entity():
	return entity












