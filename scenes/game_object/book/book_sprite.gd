extends Sprite2D

@export var TEXTURE_ARRAY: Array[Texture]
# Called when the node enters the scene tree for the first time.
func _ready():
	choose_texture()


func choose_texture()-> void:
	var idx: int = randi_range(0, 2)
	texture = TEXTURE_ARRAY[idx]
