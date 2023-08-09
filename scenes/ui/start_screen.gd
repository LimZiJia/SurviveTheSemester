extends Control

@export var controls_menu_scene: PackedScene
@export var volume_menu_scene: PackedScene

@onready var start_button := %StartButton as HoverableButton
@onready var controls_button := %ControlsButton as HoverableButton
@onready var volume_button := %VolumeButton as HoverableButton
@onready var quit_button := %QuitButton as HoverableButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)
	volume_button.pressed.connect(on_volume_button_pressed)
	quit_button.pressed.connect(get_tree().quit)


# Emits game_started signal globally which is picked up
# by the GameManager singleton which changes the scene
func _on_start_button_pressed() -> void:
	Events.game_started.emit()


func _on_controls_button_pressed() -> void:
	var controls_menu_instance := controls_menu_scene.instantiate() as CanvasLayer
	add_child(controls_menu_instance)


func on_volume_button_pressed() -> void:
	var volume_menu_instance := volume_menu_scene.instantiate() as CanvasLayer
	add_child(volume_menu_instance)
