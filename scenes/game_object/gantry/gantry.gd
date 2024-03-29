extends StaticBody2D

@onready var area_2d := $Area2D as Area2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	area_2d.body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	animation_player.play("reject")
	AudioManager.play_2d_audio("gantry", self, -20.0, 1.5)
