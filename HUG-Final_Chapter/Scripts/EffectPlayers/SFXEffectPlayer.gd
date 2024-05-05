extends EffectPlayer




# Stats
export (NodePath) var audiostream_path: NodePath
var audiostream = null



# Play effect
func play_effect():
	if is_instance_valid(audiostream) == false:
		audiostream = get_node(audiostream_path)

	audiostream.play()
