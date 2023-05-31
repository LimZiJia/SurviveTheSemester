extends Control

@onready var start_button: HoverableButton = \
	$CenterContainer/MarginContainer/VBoxContainer/StartButton
@onready var options_button: HoverableButton = \
	$CenterContainer/MarginContainer/VBoxContainer/OptionsButton
@onready var quit_button: HoverableButton = \
	$CenterContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(get_tree().quit)


# Emits game_started signal globally which is picked up
# by the GameManager singleton which changes the scene
func _on_start_button_pressed() -> void:
	Events.game_started.emit()


func _on_options_button_pressed() -> void:
	SceneChanger.change_scene("res://gui/settings_menu.tscn")
