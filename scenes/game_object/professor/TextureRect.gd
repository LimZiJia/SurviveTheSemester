extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:x", 12, 0.05)
	tween.tween_property(self, "position:x", 6, 0.05)
