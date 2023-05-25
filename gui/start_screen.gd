extends Control

@onready var start_button := \
	$CenterContainer/MarginContainer/VBoxContainer/StartButton
@onready var quit_button := \
	$CenterContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(start)
	quit_button.pressed.connect(get_tree().quit)


func start() -> void:
	Events.game_started.emit()
