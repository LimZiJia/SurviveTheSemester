extends TextureProgressBar

@onready var global := get_node("/root/Global")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global != null:
		value = int((global.health / global.max_health) * 100)
	else:
		value = 0
