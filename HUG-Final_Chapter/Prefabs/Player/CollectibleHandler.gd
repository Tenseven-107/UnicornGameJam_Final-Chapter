extends Node
class_name CollectibleHandler



# Abilities array
var current_collectibles: Array = []

# Constants
const save_path: String = "user://CollectibleSave.save"
const group_name: String = "CollectibleHandler"

# Clear save
export var _c_clear_save: String
export (bool) var clear_save: bool = false
export (bool) var do_not_load: bool = false

# Effect players
export var _c_effect_players: String
export (Array, NodePath) var effects_add



# Set up
func _ready():
	add_to_group(group_name)

	if clear_save == false or do_not_load == true:
		load_save()

	else: clear_file()



# Write abilities
func save():
	var save_file: File = File.new()
	save_file.open(save_path, File.WRITE)

	save_file.store_line(JSON.print(current_collectibles))
	save_file.close()


# Load the abilities save
func load_save():
	var save_file: File = File.new()
	save_file.open(save_path, File.READ)

	if save_file.file_exists(save_path) == true and save_file.get_len() > 0:
		current_collectibles = str2var(save_file.get_line())

	save_file.close()


# Removes the save file
func clear_file():
	var save_file: File = File.new()
	save_file.open(save_path, File.WRITE)
	save_file.close()



# Add ability
func collect(new_collectible_id: String):
	current_collectibles.append(new_collectible_id)

	# Play effects on add
	for effect in effects_add:
		var play_effect: EffectPlayer = get_node(effect)
		play_effect.play_effect()



func get_collectible_amount():
	return current_collectibles.size()

