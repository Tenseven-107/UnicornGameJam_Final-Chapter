extends Sprite




export (Array, AtlasTexture) var sprites: Array



# Set up
func _ready():
	var rand_number: int = rand_range(0, sprites.size())
	texture = sprites[rand_number]
