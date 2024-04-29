extends Area2D




# Objects
var ability_handler: AbilityHandler

# Variables
export (String) var ability: String = "has_attack"
export (String) var target_group: String = "Player"

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_pickup



# Setup
func _ready():
	var handlers: Array = get_tree().get_nodes_in_group(AbilityHandler.group_name)
	ability_handler = handlers[0]

	self.connect("body_entered", self, "check_pickup")



# Pick up
func check_pickup(body: Node):
	if body.is_in_group(target_group):
		ability_handler.add_ability(ability)

		# Play effects on pick up
		for effect in effects_pickup:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

		self.call_deferred("queue_free")
