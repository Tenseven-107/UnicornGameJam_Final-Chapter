extends Area2D
class_name Collectible



# Objects
var collectible_handler: CollectibleHandler

# Variables
export (String) var id: String = "help"

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_pickup



# Setup
func _ready():
	var handlers: Array = get_tree().get_nodes_in_group(CollectibleHandler.group_name)
	collectible_handler = handlers[0]

	self.connect("body_entered", self, "check_pickup")

	# Check if already picked up
	check_is_already_picked()



# Pick up
func check_pickup(body: Node):
	if body.is_in_group(PlayerController.group_name):
		collectible_handler.collect(id)

		# Play effects on pick up
		for effect in effects_pickup:
			var play_effect: EffectPlayer = get_node(effect)
			play_effect.play_effect()

		self.call_deferred("queue_free")



# Check if the item is already picked up
func check_is_already_picked():
	var save_path: String = CollectibleHandler.save_path

	var save_file: File = File.new()
	save_file.open(save_path, File.READ)

	if save_file.file_exists(save_path) == true and save_file.get_len() > 0:
		var current_collectibles: Array = str2var(save_file.get_line())

		for c_id in current_collectibles:
			if c_id == id:
				save_file.close()

				call_deferred("queue_free")

	save_file.close()




