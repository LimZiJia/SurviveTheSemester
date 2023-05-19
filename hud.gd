extends CanvasLayer

signal start_game

func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


func show_message(text: String) -> void:
	$MessageLabel.text = text
	$MessageLabel.show()


func show_message_with_time(text: String, time: float) -> void:
	show_message(text)
	$MessageTimer.start(time)


func show_game_over() -> void:
	show_message_with_time("Game Over", 2.0)
	await($MessageTimer.timeout)
	show_message("Survive The Semester")
	await(get_tree().create_timer(1.0).timeout)
	$StartButton.show()


func _on_start_button_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_message_timer_timeout():
	$MessageLabel.hide()
