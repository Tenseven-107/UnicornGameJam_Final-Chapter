extends StaticBody2D
class_name TeleportBlock


# A wrapper scipt to block the drone and player from using the teleport ability


const MASK: int = 64
const LAYER: int = 64


func _ready():
	collision_mask = MASK
	collision_layer = LAYER
