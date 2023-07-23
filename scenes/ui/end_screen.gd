extends CanvasLayer

var save_game: SaveGame
var score: int:
	set = set_score

@onready var game_over_timer := $GameOverTimer as Timer
@onready var message_label := %MessageLabel as Label
@onready var score_label := %ScoreLabel as Label
@onready var highscore_label := %HighscoreLabel as Label

@onready var replay_button = %ReplayButton as Button
@onready var main_menu_button = %MainMenuButton as Button

func _ready() -> void:
	get_tree().paused = true
	
	replay_button.pressed.connect(on_replay_button_pressed)
	main_menu_button.pressed.connect(on_main_menu_button_pressed)


func on_replay_button_pressed() -> void:
	Events.game_restarted.emit()
	get_tree().paused = false
	queue_free()


func on_main_menu_button_pressed() -> void:
	SceneChanger.change_scene("res://scenes/ui/start_screen.tscn")
	get_tree().paused = false
	queue_free()


func set_score(score: int) -> void:
	if SaveGame.save_exists():
		save_game = SaveGame.load_savegame() as SaveGame
	else:
		save_game = SaveGame.new()
	
	if score > save_game.highscore:
		save_game.highscore = score
		message_label.text = "New Highscore!"
	
	save_game.write_savegame()
	
	score_label.text = "Score: %s" % format_seconds_to_string(score)
	highscore_label.text = "Highscore: %s" % format_seconds_to_string(save_game.highscore)


func format_seconds_to_string(seconds: int) -> String:
	var hours = floor(seconds / 3600.0)
	var minutes = floor(int(seconds / 60.0) % 60)
	var remaining_seconds = seconds % 60
	if hours == 0:
		return "%d:%02d" % [minutes, remaining_seconds]
	else:
		return "%d:%02d:%02d" % [hours, minutes, remaining_seconds]
