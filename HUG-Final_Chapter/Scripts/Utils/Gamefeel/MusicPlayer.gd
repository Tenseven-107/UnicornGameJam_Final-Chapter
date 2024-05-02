extends Node
class_name MusicPlayer_class



# Objects
onready var audioplayer = $AudioPlayer


# Variables
export (Array, String, FILE, "*.mp3") var default_song_list: Array
var used_songs: Array
var current_song_idx: int = 0

# Paths
const song_folder = "user://Tracks" # Folder on the user's system that contains all the tracks



# Set up
func _ready():
	check_song_files()


# - Setting and checking the song directory
func check_song_files():
	# Create a directory object to look through our directory
	var dir = Directory.new()

	# if our directory exists, we shall check if it has the amount of songs the game needs
	if dir.dir_exists(song_folder):
		var song_number: int = 0
		dir.open(song_folder)

		# Cycle through the directory to check if it contains all the songs we need
		for song in default_song_list:
			var song_path: String = get_song_path(song)
			if dir.file_exists(song_path) and song != default_song_list[0]:
				song_number += 1

		# If there aren't enough songs we create a new directory
		if song_number < (default_song_list.size() - 1):
			push_warning("NOTE: Insufficient song files found in directory " + song_folder + 
			". Creating new song directory.")
			create_song_directory()

	else:
		# If there is no directory we make a new one
		push_warning("NOTE: Creating new song directory.")
		create_song_directory()

	# Get all the song paths in the directory
	dir.open(song_folder)
	if dir.open(song_folder) == OK:
		dir.list_dir_begin(true, true)
		var file_name: String = dir.get_next()

		while file_name != "":
			used_songs.append(file_name)
			file_name = dir.get_next()


# Creating the directory
func create_song_directory():
	var dir = Directory.new()

	# If the directory already existed, remove it
	if dir.dir_exists(song_folder):
		dir.remove(song_folder)

		push_warning("NOTE: Directory exists already, removing old directory.")

	# Making the directory
	dir.make_dir(song_folder)

	# Adding songs to the directory
	for song in default_song_list:
		var file = File.new()
		var song_path: String = get_song_path(song)

		var song_file = ResourceLoader.load(song)
		var data = song_file.get_data()

		file.open(song_path, File.WRITE)
		file.store_buffer(data)

		file.close()



# Get the path of a song in the song_folder
func get_song_path(path: String):
	var song_path: String = song_folder + "/" + path.split("/")[4]
	return song_path

# Get a song in the array of used_songs
func get_used_song_path(idx: int):
	if idx > (used_songs.size() - 1):
		push_error("ERROR: No soundfile found at index " + str(idx) + ", returnning empty string.")
		return ""

	var song_path: String = song_folder + "/" + used_songs[idx]
	return song_path



# Setting the song
func set_song(idx: int) -> void:
	# We get the path of our file
	var current_song_path: String = get_used_song_path(idx)

	# If no song path is found, we do nothing
	if current_song_path != "" and (current_song_path != get_used_song_path(current_song_idx) or audioplayer.stream == null):
		# Set the current song index to idx (for debugging)
		current_song_idx = idx

		# Open a new file so we can read the bytes of our audiofile. 
		var file = File.new()

		# We check if the directory and our song  still exists, if not, make a new one
		var dir = Directory.new()
		if dir.dir_exists(song_folder) == false and dir.file_exists(current_song_path) == false:
			create_song_directory()

		# Open the sound file
		if dir.file_exists(current_song_path) == true:
			file.open(current_song_path, File.READ)

		# Get and create new resource for the audiostream player
		var current_song_data: PoolByteArray = file.get_buffer(file.get_len())
		var new_audio_resource = AudioStreamMP3.new()

		new_audio_resource.set_data(current_song_data)
		new_audio_resource.loop = true

		# Close the audio file we use
		file.close()

		# Set the audiostream player's stream to our song and play
		audioplayer.stream = new_audio_resource
		audioplayer.play()

	return






