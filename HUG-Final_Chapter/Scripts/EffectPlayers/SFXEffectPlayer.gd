extends EffectPlayer




# Stats
export (NodePath) var audiostream_path: NodePath
onready var audiostream: AudioStreamPlayer = get_node(audiostream_path)



# Play effect
func play_effect():
	audiostream.play()
