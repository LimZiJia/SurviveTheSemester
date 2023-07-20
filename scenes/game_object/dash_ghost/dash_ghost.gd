extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)


func clone(sprite: Sprite2D) -> void:
	self.texture = sprite.texture
	self.vframes = sprite.vframes
	self.hframes = sprite.hframes
	self.frame = sprite.frame
	self.flip_h = sprite.flip_h
	self.flip_v = sprite.flip_v
