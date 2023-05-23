extends Control

@export var game_scene: PackedScene

@onready var start_button := \
	$CenterContainer/MarginContainer/VBoxContainer/StartButton
@onready var quit_button := \
	$CenterContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(start)
	quit_button.pressed.connect(get_tree().quit)


func start() -> void:
	get_tree().change_scene_to_packed(game_scene)
