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

export (NodePath) var anim_tree_path: NodePath
onready var anim_tree: AnimationTree = get_node(anim_tree_path)
var anims: AnimationNodeStateMachinePlayback

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

# - Other
export (NodePath) var dead_cooldown_path: NodePath
onready var dead_cooldown: Timer = get_node(dead_cooldown_path)

export (NodePath) var start_timer_path: NodePath
onready var start_timer: Timer = get_node(start_timer_path)


# - Drone
export var _c_drone_player: String
export (NodePath) var drone_path: NodePath
onready var drone: PlayerDroneController = get_node(drone_path)

# - HUD
export var _c_hud: String
export (NodePath) var hud_path: NodePath
onready var hud: PlayerHud = get_node(hud_path)


# Movement
export var _c_movement: String
export (float) var move_speed: float = 10000

# - Jumping
export var _c_jumping: String
export (float) var jump_force: float = 380
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
var input_vector: Vector2 =  Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO


# Attacking
export var _c_combat: String
export (int) var damage: int = 2
export (int) var damage_team: int = 0

export (float) var attack_ray_reach: float = 45
export (float) var attack_time: float = 0.1
export (float) var attack_cooldown_time: float = 0.2
onready var ATTACK_COOLDOWN: float = attack_time + attack_cooldown_time


# Dodging
export var _c_dodge_roll: String
export (float) var dodge_time: float = 0.36


# Stamina
export var _c_stamina: String
export (int) var stamina: int = 100
var current_stamina: int = 0
var tired: bool = false

export (int) var stamina_attack: int = 15
export (int) var stamina_dodge: int = 30
export (int) var stamina_teleport: int = 100


# States
export var _c_states: String
enum STATES {
	ACTIVE,
	WALK,
	UNACTIVE
}
export (STATES) var current_state: int = STATES.ACTIVE


# Switches
export var _c_switches: String
export (bool) var has_jump: bool = true
export (bool) var has_attack: bool = true
export (bool) var has_teleport: bool = true


# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_teleport_in
export (Array, NodePath) var effects_teleport_out

export (Array, NodePath) var effects_attack
export (Array, NodePath) var effects_attack_hit
export (Array, NodePath) var effects_roll
export (Array, NodePath) var effects_jump

export (Array, NodePath) var effects_ground
var effect_grounded: bool = false

export (Array, NodePath) var effects_no_stamina
export (Array, NodePath) var effects_not_enough_stamina

# Misc
export var _c_misc: String
export (float) var start_time: float = 1.5
export (float) var dead_time: float = 2

const group_name: String = "Player"



# Set up
func _ready():
	add_to_group(group_name)

	# General setup
	switch_state(STATES.UNACTIVE) # Starts in the unactive state to transition smoothly into gameplay

	sprite.flip_h = true
	anim_tree.active = true
	anims = anim_tree.get("parameters/playback")
	anims.start("Start")

	input_vector.x = 1
	last_x_input = input_vector.x

	current_stamina = stamina
	tired = false

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

	# Entity
	GlobalSignals.connect("heal_player", entity, "handle_heal")
	entity.connect("dead", self, "set_dead")

	# Misc
	start_timer.connect("timeout", self, "set_active")
	start_timer.wait_time = start_time
	start_timer.one_shot = true
	start_timer.start() # countdown till active when spawned in

	dead_cooldown.wait_time = dead_time
	dead_cooldown.one_shot = true
	dead_cooldown.connect("timeout", self, "signal_dead")

	# Update Hud
	entity.connect("update_hp", hud, "set_hp")
	entity.emit_signal("update_hp", entity.get_hp(), entity.get_max_hp())
	hud.set_stamina(current_stamina, stamina)

	# Set up rays
	for ray in raycasts:
		get_node(ray).add_exception(self)



# Processing
func _physics_process(delta):
	set_velocity(delta)
	stamina_regen()

func _process(delta):
	run_states(delta)


# Running the states
func run_states(delta):
	match current_state:
		STATES.ACTIVE:
			movement(delta)
			dodging()
			if has_jump == true: jumping(delta)
			if has_attack == true: attacking()
			if has_teleport == true: teleport()
			return

		STATES.WALK: # Player has no control anymore
			current_gravity = gravity
			input_vector.y = 0
			input_vector.x = ceil(last_x_input)
			anims.travel("Walk")
			return

		STATES.UNACTIVE:
			input_vector = Vector2.ZERO
			velocity = Vector2.ZERO
			return

func switch_state(new_state: int):
	if new_state > STATES.size() - 1:
		current_state = STATES.ACTIVE

	else:
		current_state = new_state



# Movement
func movement(delta):
	if attack_cooldown.is_stopped() and dodge_timer.is_stopped():
		input_vector.x = Input.get_axis("left_player", "right_player")
	if input_vector.x != 0:  
		last_x_input = input_vector.normalized().x

		if check_rays(false) == true: anims.travel("Walk")
	else: if check_rays(false) == true: anims.travel("Idle")

	# Turning the players direction
	if input_vector.x > 0: 
		sprite.flip_h = true
		attack_ray.cast_to.x = attack_ray_reach
	elif input_vector.x < 0: 
		sprite.flip_h = false
		attack_ray.cast_to.x = -attack_ray_reach


func jumping(delta):
	# Initiating jump
	if Input.is_action_just_pressed("jump") and (check_rays(false) == true or coyote_timer.is_stopped() == false):
		is_jumping = true

		# Coyote jump
		if coyote_timer.is_stopped() == false and is_on_floor() == false and check_rays(false) == false:
			coyote = true

		coyote_timer.stop()
		anims.start("Jump")

		# Play effects on jump
		for effect in effects_jump:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

	# Jumping
	if Input.is_action_pressed("jump") and is_jumping == true:
		input_vector.y = get_jump_force()

		if current_gravity > min_gravity:
			current_gravity -= gravity_depletion

	# Release jump
	if Input.is_action_just_released("jump") or current_gravity <= min_gravity:
		is_jumping = false
		current_gravity = gravity
		input_vector.y = 0

func get_jump_force():
	return jump_force if coyote == false else coyote_jump_force



# Check is raycasts are colliding
func check_rays(check_if_drone: bool):
	for raycast in raycasts:
		var object: RayCast2D = get_node(raycast)
		if (object.is_colliding() and check_if_drone == false or 
		(check_if_drone == true and object.get_collider() is PlayerDroneController)):

			return true
	return false



# Setting the velocity
func set_velocity(delta):
	velocity.x = (input_vector.x * move_speed) * delta
	if is_on_floor() == false or check_rays(true) == true: velocity.y += current_gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_floor() == true or coyote == true:
		if is_jumping == true: velocity.y -= input_vector.y
		else: 
			velocity.y = 0 # nullify the velocity to avoid constant velocity into the ground

			coyote_timer.start()
		coyote = false

		# Play effects on grounded
		if effect_grounded == false and check_rays(false) == true:
			effect_grounded = true
			for effect in effects_ground:
				var play_effect: EffectPlayer = get_node(effect)
				play_effect.play_effect()

	else: 
		if check_rays(false) == false: 
			anims.travel("Fall")
			effect_grounded = false



# Combat
func attacking():
	if player_action("attack_player", true) and can_remove_stamina(stamina_attack, true):
		input_vector.x = last_x_input

		attack_timer.start()
		attack_cooldown.start()

		if attack_ray.is_colliding():
			var colliding_entity = attack_ray.get_collider()
			if colliding_entity.is_in_group(Entity.group_name):
				colliding_entity.handle_hit(damage_team, damage)

			# Play effects on attack hit
			for effect in effects_attack_hit:
				var play_effect: EffectPlayer = get_node(effect)
				play_effect.play_effect()

		anims.start("Attack")

		# Play effects on attack
		for effect in effects_attack:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

func attack_recovery():
	input_vector.x = 0



# ROLLING ROLLING ROLLING ROLLING
func dodging():
	if player_action("action_player", true) and can_remove_stamina(stamina_dodge, true):
		input_vector.x = last_x_input

		entity.invincible = true
		dodge_timer.start()

		anims.start("Roll")

		# Play effects on dodge
		for effect in effects_roll:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

func finish_dodge():
	input_vector.x = 0
	entity.invincible = false



# Teleport
func teleport():
	if player_action("action_player", false) and drone.check_can_teleport():
		if can_remove_stamina(stamina_teleport, false):
			# Play effects on teleport_in
			for effect in effects_teleport_in:
				var play_effect: EffectPlayer = get_node(effect)
				play_effect.play_effect()

			global_position = drone.get_teleport_pos()

			# Play effects on teleport_out
			for effect in effects_teleport_out:
				var play_effect: EffectPlayer = get_node(effect)
				play_effect.play_effect()



# Used to check if the player can do a certain action besides simply moving
func player_action(control_action: String, on_floor: bool):
	if (Input.is_action_just_pressed(control_action) and ((on_floor == true and is_on_floor()) or on_floor == false)
	and attack_cooldown.is_stopped() 
	and dodge_timer.is_stopped()):
		return true
	return false



# Stamina
func stamina_regen():
	if attack_cooldown.is_stopped() and dodge_timer.is_stopped():
		if current_stamina < stamina:
			current_stamina += 1

			hud.set_stamina(current_stamina, stamina) # Set the hud_stamina
		else: 
			tired = false
			current_stamina = clamp(current_stamina, 0, stamina)

func can_remove_stamina(removed_stamina: int, can_play_effect: bool):
	if (current_stamina - removed_stamina) >= 0 and tired == false:
		current_stamina -= removed_stamina

		hud.set_stamina(current_stamina, stamina) # Set the hud_stamina

		if current_stamina <= 0:
			tired = true

			# Play effects on no stamina
			if can_play_effect == true:
				for effect in effects_no_stamina:
					var play_effect: EffectPlayer = get_node(effect)
					play_effect.play_effect()

		return true

	# Play effects on having not enough stamina
	for effect in effects_not_enough_stamina:
		var play_effect: EffectPlayer = get_node(effect)
		play_effect.play_effect()

	return false



# Set to dead state
func set_dead(): 
	switch_state(STATES.UNACTIVE)
	dead_cooldown.start()

func signal_dead():GlobalSignals.emit_signal("gameover")


#Set to active
func set_active(): 
	switch_state(STATES.ACTIVE)







