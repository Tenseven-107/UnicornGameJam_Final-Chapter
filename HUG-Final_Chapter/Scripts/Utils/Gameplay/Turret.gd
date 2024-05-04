extends Node2D



onready var ray: RayCast2D = $Utils/RayCast2D

# For level design
export var _c_for_level_designs: String
export (bool) var right: bool = true

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_hit



# Set up
func _ready():
	if right == false:
		self.scale.x = -1


# When detected, activate
func _process(delta):
	if ray.is_colliding():
		# Play effects on hit
		for effect in effects_hit:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()
