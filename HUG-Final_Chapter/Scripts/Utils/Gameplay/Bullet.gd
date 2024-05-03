extends KinematicBody2D
class_name Bullet


# Objects
onready var sprite = $Sprites/Sprite

onready var collider = $Collider
onready var dropoff_timer = $Dropoff_timer

onready var collision_tween = $Collision_tween
onready var dropoff_tween = $Dropoff_tween

export (NodePath) var trail_path: NodePath

# Stats
# - Stats
export (int, 2, 100) var times_ricochet: int = 4
export (bool) var can_ricochet: bool = true

export (int) var speed: int = 500
var velocity = Vector2.ZERO

export (float) var dropoff_time: float = 10
export (bool) var wall_piercing: bool = false

enum TRANSITIONTYPE {
	LINEAR,
	SINE,
	QUINT,
	QUART,
	QUAD,
	EXPO,
	ELASTIC,
	CUBIC,
	CIRC,
	BOUNCE,
	BACK
}
export (TRANSITIONTYPE) var dropoff_transition_type: int = 0

# Physics layers
const LAYER: int = 8
const MASK: int = 8

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_on_impact: Array



# Set up
func _ready():
	velocity = Vector2(speed, 0).rotated(rotation)
	dropoff_timer.wait_time = dropoff_time
	dropoff_timer.start()

	dropoff_timer.connect("timeout", self, "dropoff")

	# Setting up physics layers
	collision_layer = LAYER
	collision_mask = MASK



# Process
func _physics_process(delta):
	move(delta)



# Moving and colliding
func move(delta):
	# Moving
	var collision = move_and_collide(velocity * delta)

	# Ricochetting
	if collision:
		if can_ricochet == true:
			var rot: float = rotation
			var reflect = collision.remainder.bounce(collision.normal)

			times_ricochet -= 1
			velocity = velocity.bounce(collision.normal)
			move_and_collide(reflect)

			rotation = -rot

		collision_tween.interpolate_property(collider, "disabled", true, false, 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		collision_tween.start()

		# Play effects on impact
		for effect in effects_on_impact:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

		# Remove when cant ricochet
		if (((can_ricochet == false and collision) or (collision and times_ricochet <= 0)) and 
		wall_piercing == false):
			queue_free()



# Dropoff
func dropoff():
	dropoff_tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2.ZERO, 0.1, 
	dropoff_transition_type, Tween.EASE_IN_OUT)
	dropoff_tween.start()

	if trail_path.is_empty() == false:
		var trail = get_node(trail_path)
		trail.trail_active = false

	dropoff_tween.connect("tween_all_completed", self, "destroy")

func destroy():
	call_deferred("queue_free")





