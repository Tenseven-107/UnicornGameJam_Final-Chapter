extends KinematicBody2D



# Objects
export var _c_Objects: String

onready var hitbox: Hitbox = $Combat/Hitbox

onready var move_ray: RayCast2D = $Rays/Moveray
onready var stop_ray: RayCast2D = $Rays/Stopray
export (Array, NodePath) var interupt_ray_paths: Array
var interupt_rays: Array

# Movement
export (float) var down_speed: float = 280
export (float) var up_speed: float = 75

var charge: bool = false

var original_pos: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# Effect players
export var _c_hit: String
export (Array, NodePath) var effects_hit



# Set up
func _ready():
	stop_ray.add_exception(self)
	original_pos = global_position
	charge = false

	for path in interupt_ray_paths:
		var node = get_node(path)
		if node is RayCast2D:
			interupt_rays.append(node)



# Processing
func _physics_process(delta):
	movement(delta)


# Movement
func movement(delta):
	if charge == true and stop_ray.is_colliding() == false:
		velocity.y = down_speed
		hitbox.active = true
	if charge == false:
		if global_position.y > original_pos.y:
			velocity.y = -up_speed
		else: velocity.y = 0

		hitbox.active = false

	if check_interupt_rays() == false:
		move_and_collide(velocity * delta)

	if stop_ray.is_colliding() == true and check_interupt_rays() == false:
		charge = false
		# Play effects on hit
		for effect in effects_hit:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

	elif move_ray.is_colliding() == true and (global_position.y > original_pos.y) == false:
		charge = true


# Get if interupt rays are colliding
func check_interupt_rays():
	for ray in interupt_rays:
		if ray.is_colliding():
			return true
	return false







