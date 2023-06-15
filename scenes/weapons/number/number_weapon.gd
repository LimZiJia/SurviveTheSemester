extends Node2D

@onready var sprite_2d = $Visuals/Sprite2D


func _ready() -> void:
	pick_number()


func pick_number() -> void:
	sprite_2d.frame = randi_range(0, 9)
