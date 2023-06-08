extends CanvasLayer

@onready var replay_button = %ReplayButton as Button
@onready var main_menu_button = %MainMenuButton as Button

func _ready() -> void:
	get_tree().paused = true
	
	$GameOverTimer.timeout.connect(on_game_over_timer_timeout)
	replay_button.pressed.connect(on_replay_button_pressed)
	main_menu_button.pressed.connect(on_main_menu_button_pressed)


func on_game_over_timer_timeout() -> void:
	$MessageLabel.text = "Survive The Semester"


func on_replay_button_pressed() -> void:
	Events.game_restarted.emit()
	get_tree().paused = false
	queue_free()


func on_main_menu_button_pressed() -> void:
	SceneChanger.change_scene("res://gui/start_screen.tscn")
	get_tree().paused = false
	queue_free()
