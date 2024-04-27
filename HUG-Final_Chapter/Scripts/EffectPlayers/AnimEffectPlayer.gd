extends EffectPlayer


# Objects
export (NodePath) var animation_player_path: NodePath
var anim_player: AnimationPlayer

# Variables
export (String) var animation_name: String
export (bool) var check_animation: bool = false
export (bool) var check_if_playing: bool = false



# Play animation
func play_effect():
	# Get anim player
	if is_instance_valid(anim_player) == false:
		anim_player = get_node(animation_player_path)

	# Check if can play animation and play
	if (((check_animation == true and anim_player.current_animation != animation_name) 
	or check_animation == false) and 
	((check_if_playing == true and anim_player.current_animation == "")
	or check_if_playing == false)):

		anim_player.stop()
		anim_player.play(animation_name)
