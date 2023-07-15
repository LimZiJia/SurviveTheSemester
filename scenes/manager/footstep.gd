extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.movement_changed.connect(on_movement_changed)

func on_movement_changed(moving: bool) -> void:
	if moving:
		self.play()
	else:
		self.stop()
