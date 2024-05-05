extends Area2D



# objects
var game_over_handler: GameOverHandler
var collectible_handler: CollectibleHandler

onready var sprite: Sprite = $Visuals/Sprite

export (NodePath) var transit_timer_path: NodePath
onready var transit_timer: Timer = get_node(transit_timer_path)

# Variables
export (float) var transit_time: float = 1.5


# Level editing
export var _c_for_level_editing: String

export (bool) var right: bool = true
export (Vector2) var next_scene_pos: Vector2 = Vector2.ZERO
export (String, FILE, "*.tscn") var next_scene: String = "res://Scenes/Testing/Testing2.tscn"

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_enter



# Setup
func _ready():
	game_over_handler = get_tree().get_nodes_in_group(GameOverHandler.group_name)[0]
	collectible_handler = get_tree().get_nodes_in_group(CollectibleHandler.group_name)[0]

	if right == false: sprite.flip_h = true
	transit_timer.wait_time = transit_time
	transit_timer.one_shot = true

	self.connect("body_entered", self, "transit")
	transit_timer.connect("timeout", self, "change_scene")


# Activate checkpoint
func transit(body: Node):
	if body.is_in_group(PlayerController.group_name):
		game_over_handler.save_checkpoint(next_scene, next_scene_pos)

		var player: PlayerController = body
		player.switch_state(PlayerController.STATES.WALK)

		collectible_handler.save()

		transit_timer.start()

		# Play effects on enter
		for effect in effects_enter:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()



# Change scene
func change_scene():
	get_tree().change_scene(next_scene)










