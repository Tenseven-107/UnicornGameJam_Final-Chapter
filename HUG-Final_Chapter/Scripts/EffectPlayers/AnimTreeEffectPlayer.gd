extends EffectPlayer



# Variables
export (NodePath) var anim_tree_path: NodePath
var anim_playback: AnimationNodeStateMachinePlayback

export (String) var animation_name: String = "Idle"
export (bool) var travel: bool = true



func play_effect():
	if is_instance_valid(anim_playback) == false:
		anim_playback = get_node(anim_tree_path).get("parameters/playback")

	if travel == true:
		anim_playback.travel(animation_name)
	else: anim_playback.start(animation_name)
