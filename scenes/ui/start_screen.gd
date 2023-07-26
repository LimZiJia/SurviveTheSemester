extends Control

@export var volume_menu_scene: PackedScene

@onready var start_button := %StartButton as HoverableButton
@onready var options_button := %OptionsButton as HoverableButton
@onready var volume_button := %VolumeButton as HoverableButton
@onready var quit_button := %QuitButton as HoverableButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	volume_button.pressed.connect(on_volume_button_pressed)
	quit_button.pressed.connect(get_tree().quit)


# Emits game_started signal globally which is picked up
# by the GameManager singleton which changes the scene
func _on_start_button_pressed() -> void:
	Events.game_started.emit()


func _on_options_button_pressed() -> void:
	SceneChanger.change_scene("res://scenes/ui/settings_menu.tscn")


func on_volume_button_pressed() -> void:
	var volume_menu_instance := volume_menu_scene.instantiate() as CanvasLayer
	add_child(volume_menu_instance)
