extends Area2D


# objects
var game_over_handler: GameOverHandler

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_enter



# Setup
func _ready():
	game_over_handler = get_tree().get_nodes_in_group(GameOverHandler.group_name)[0]

	self.connect("body_entered", self, "activate_checkpoint")




# Activate checkpoint
func activate_checkpoint(body: Node):
	if body.is_in_group(PlayerController.group_name):
		var current_scene: String = get_tree().current_scene.filename
		game_over_handler.save_checkpoint(current_scene, global_position)

		# Play effects on enter
		for effect in effects_enter:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()
