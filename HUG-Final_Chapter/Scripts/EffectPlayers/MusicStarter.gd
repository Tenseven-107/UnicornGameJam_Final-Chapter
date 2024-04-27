extends EffectPlayer
class_name MusicStarter


# Song started by this effect-player
export (int) var song_index: int = 0


# Play the song
func play_effect():
	MusicPlayer.set_song(song_index)


