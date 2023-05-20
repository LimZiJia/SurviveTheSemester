extends ColorRect

@onready var resume_button: Button = \
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var restart_button: Button = \
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/RestartButton
@onready var quit_button: Button = \
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(restart)
	quit_button.pressed.connect(get_tree().quit)


func pause() -> void:
	self.visible = true
	get_tree().paused = true


func resume() -> void:
	self.visible = false
	get_tree().paused = false


func restart() -> void:
	self.visible = false
	get_tree().paused = false
	owner.restart_game()
