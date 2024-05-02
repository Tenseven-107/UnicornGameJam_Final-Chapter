extends Node
class_name AbilityHandler



# Player
export (NodePath) var player_path: NodePath
onready var player: PlayerController = get_node(player_path)

# Abilities array
var abilities: Array = []
export (Array, String) var variable_abilities: Array

# Constants
const save_path: String = "user://AbilitySave.save"
const group_name: String = "AbilityHandler"

# Clear save
export var _c_clear_save: String
export (bool) var clear_save: bool = false


# Set up
func _ready():
	add_to_group(group_name)

	if clear_save == false:
		load_save()
		set_abilities()

	else: clear_file()



# Write abilities
func save():
	var save_file: File = File.new()
	save_file.open(save_path, File.WRITE)

	save_file.store_line(JSON.print(abilities))
	save_file.close()


# Load the abilities save
func load_save():
	var save_file: File = File.new()
	save_file.open(save_path, File.READ)

	if save_file.file_exists(save_path) == true and save_file.get_len() > 0:
		abilities = str2var(save_file.get_line())
	else:
		save()

	save_file.close()


# Removes the save file
func clear_file():
	var save_file: File = File.new()
	save_file.open(save_path, File.WRITE)
	save_file.close()



# set up player abilities
func set_abilities():
	for ability in abilities:
		for variable in variable_abilities:
			if ability == variable:
				player.set(variable, true)



# Add ability
func add_ability(new_ability: String):
	if abilities.size() > 0:
		for ability in abilities:
			if new_ability == ability:
				return

	abilities.append(new_ability)
	set_abilities()
	save()




