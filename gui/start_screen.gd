extends Control

@onready var start_button := \
	$CenterContainer/MarginContainer/VBoxContainer/StartButton
@onready var options_button := \
	$CenterContainer/MarginContainer/VBoxContainer/OptionsButton
@onready var quit_button := \
	$CenterContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(start)
	options_button.pressed.connect(options)
	quit_button.pressed.connect(get_tree().quit)


func start() -> void:
	Events.game_started.emit()


func options() -> void:
	SceneChanger.change_scene("res://gui/settings_menu.tscn")
