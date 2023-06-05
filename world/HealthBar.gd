extends TextureProgressBar

@onready var player := get_node("/root/PlayerScene")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player = get_node("/root/PlayerScene")
	if player != null:
		value = int((player.health / player.max_health) * 100)
	else:
		value = 0
