extends Node
class_name GameOverHandler



# Objects
var player: PlayerController
var drone: PlayerDroneController

onready var drone_tp_timer: Timer = $Timer

# Variables
export (String, FILE, "*.tscn") var default_scene: String = "res://Scenes/Main/Levels/Start.tscn"

var dead: bool = false
var last_check_point_pos: Vector2 = Vector2.ZERO

# Utils
const save_path: String = "user://CheckpointSave.save"
const group_name: String = "GameOverHandler"
const drone_tp_time: float = 0.5

# Clear save
export var _c_clear_save: String
export (bool) var clear_save: bool = false


# Setup
func _ready():
	print("Loaded Scene")

	add_to_group(group_name)
	dead = false

	if clear_save == false:
		player = get_tree().get_nodes_in_group(PlayerController.group_name)[0]
		drone = get_tree().get_nodes_in_group(PlayerDroneController.group_name)[0]

		# Set up drone tp timer
		drone_tp_timer.wait_time = drone_tp_time
		drone_tp_timer.one_shot = true
		drone_tp_timer.connect("timeout", self, "tp_drone")

		load_checkpoint()
		GlobalSignals.connect("gameover", self, "set_dead")

	else: clear_file()



# Save checkpoint
func save_checkpoint(scene_path: String, checkpoint_pos: Vector2):
	var save_file: File = File.new()
	save_file.open(save_path, File.WRITE)

	var save_array: Array = [scene_path, var2str(checkpoint_pos)]
	save_file.store_line(JSON.print(save_array))

	save_file.close()



# Load checkpoint
func load_checkpoint():
	var save_file: File = File.new()

	if save_file.file_exists(save_path) == true:
		save_file.open(save_path, File.READ)

		if save_file.get_len() > 0:
			var saved_array: Array = str2var(save_file.get_line())
			save_file.close()

			if get_tree().current_scene.filename == saved_array[0] and dead == false: # index 0 is the scene, 1 is the position of the checkpoint
				set_player_pos(str2var(saved_array[1]))

			else:
				get_tree().change_scene(saved_array[0])

		else: 
			if get_tree().current_scene.filename != default_scene: get_tree().change_scene(default_scene)
	else: 
		if get_tree().current_scene.filename != default_scene or dead: get_tree().change_scene(default_scene)



# Check checkpoint
func current_checkpoint_active(scene_path: String, checkpoint_pos: Vector2):
	var save_file: File = File.new()

	if save_file.file_exists(save_path) == true:
		save_file.open(save_path, File.READ)

		if save_file.get_len() > 0:
			var saved_array: Array = str2var(save_file.get_line())
			save_file.close()

			if saved_array[0] == scene_path and str2var(saved_array[1]) == checkpoint_pos:
				return true

			else: return false
	else:
		return false



# Setting the position of the player and drone
func set_player_pos(pos: Vector2):
	if is_instance_valid(player) and is_instance_valid(drone):
		player.global_position = pos
		last_check_point_pos = pos

		drone_tp_timer.start()


# Teleport drone to correct pos
func tp_drone():
	drone.global_position = last_check_point_pos + drone.start_offset


# Setting dead
func set_dead(): 
	dead = true
	load_checkpoint()



# Removes the save file
func clear_file():
	var save_file: File = File.new()
	save_file.open(save_path, File.WRITE)
	save_file.close()















