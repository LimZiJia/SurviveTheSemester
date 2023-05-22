extends CanvasLayer

signal start_game

@onready var score_label = $ScoreLabel
@onready var message_label = $MessageLabel
@onready var buttons = $Buttons
@onready var play_button = $Buttons/PlayButton
@onready var main_menu_button = $Buttons/MainMenuButton
@onready var message_timer = $MessageTimer

func _ready() -> void:
	play_button.pressed.connect(play_again)
	main_menu_button.pressed.connect(go_to_main)

func update_score(score: int) -> void:
	score_label.text = str(score)


func show_message(text: String) -> void:
	message_label.text = text
	message_label.show()


func hide_message() -> void:
	message_label.hide()


func show_message_with_time(text: String, time: float) -> void:
	show_message(text)
	message_timer.start(time)


func show_game_over() -> void:
	show_message_with_time("Game Over", 2.0)
	await(message_timer.timeout)
	show_message("Survive The Semester")
	await(get_tree().create_timer(1.0).timeout)
	buttons.show()


func play_again() -> void:
	buttons.hide()
	emit_signal("start_game")


func go_to_main() -> void:
	get_tree().change_scene_to_file("res://gui/start_screen.tscn")

func _on_message_timer_timeout():
	message_label.hide()
