extends CanvasLayer

@onready var resume_button: Button = \
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var restart_button: Button = \
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/RestartButton
@onready var return_button: Button = \
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ReturnButton

func _ready() -> void:
	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(restart)
	return_button.pressed.connect(return_to_main)


func pause() -> void:
	self.visible = true
	get_tree().paused = true


func resume() -> void:
	self.visible = false
	get_tree().paused = false


func restart() -> void:
	self.visible = false
	Events.game_restarted.emit()
	get_tree().paused = false
	


func return_to_main() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://gui/start_screen.tscn")
