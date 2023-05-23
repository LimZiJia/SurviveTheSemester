class_name HoverableButton
extends Button

var original_size := scale
var grow_size := Vector2(1.1, 1.1)
var dur := 0.1

func _ready() -> void:
	mouse_entered.connect(resize_button.bind(grow_size))
	mouse_exited.connect(resize_button.bind(original_size))


func resize_button(resized_size: Vector2):
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", resized_size, dur)
