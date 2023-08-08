extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pitch_scale = 0.5
	volume_db = -15.0
	speed_up()


func speed_up() -> void:
	var tween = create_tween()
	tween.tween_property(self, "pitch_scale", 1.1, 600.0)
