extends CanvasLayer

@onready var resume_button := %ResumeButton as Button
@onready var restart_button := %RestartButton as Button
@onready var return_button := %ReturnButton as Button

func _ready() -> void:
	get_tree().paused = true
	
	resume_button.pressed.connect(on_resume_button_pressed)
	restart_button.pressed.connect(on_restart_button_pressed)
	return_button.pressed.connect(on_return_button_pressed)


func on_resume_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func on_restart_button_pressed() -> void:
	get_tree().paused = false
	Events.game_restarted.emit()
	queue_free()


func on_return_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/start_screen.tscn")
	queue_free()
