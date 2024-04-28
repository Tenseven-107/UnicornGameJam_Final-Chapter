extends EffectPlayer
class_name BulletShooter



# Stats
export var _c_Stats: String
# - Misc
export var _c_Misc: String
export (int) var team: int = 0

# - Projectiles
export var _c_Projectiles: String
export (PackedScene) var projectile: PackedScene
export (int) var bullets: int = 1

# - Circle fire
export var _c_Circle: String
export (bool) var circle: bool = false

# - Fire stats
export var _c_Firing: String
export (float) var firerate_cooldown: float = 0.1

onready var firerate_timer: Timer

# - Objects
export (NodePath) var muzzle_path: NodePath
onready var muzzle = get_node(muzzle_path)
var bullet_container = null

const container_group: String = "BulletContainer"

# Juice
export var _c_effect_players: String
export (Array, NodePath) var effects_on_fire: Array



# Set up
func _ready():
	setup_timer()

func setup_timer():
	# Cooldown timer
	var firerate_instance: Timer = Timer.new()

	firerate_instance.wait_time = firerate_cooldown
	firerate_instance.one_shot = true

	add_child(firerate_instance)
	firerate_timer = firerate_instance



# Fire bullets
func play_effect():
	if is_instance_valid(bullet_container) == false:
		get_bullet_container()

	if firerate_timer.is_stopped():
		firerate_timer.start()

		var circle_steps = 2 * PI / bullets

		for bullet in range(bullets):
			# Spawning the bullets
			var bullet_instance: Bullet = projectile.instance()

			bullet_instance.global_position = muzzle.global_position
			bullet_instance.global_rotation = muzzle.global_rotation

			# - Circle effect
			if circle == true:
				var new_rot: float = circle_steps * bullet
				bullet_instance.global_rotation = new_rot

			bullet_container.call_deferred("add_child", bullet_instance)

		# Play effects on fire
		for effect in effects_on_fire:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()



# Initialization
func get_bullet_container():
	var containers = get_tree().get_nodes_in_group(container_group)
	bullet_container = containers[0]







