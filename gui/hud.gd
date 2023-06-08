extends CanvasLayer

signal start_game

var score:int = 0:
	set = set_score

@onready var blood = $Blood
@onready var statuses = $Statuses
@onready var score_label = $ScoreLabel


func update_health(frac_cur_health: float) -> void:
	blood.update_health(frac_cur_health)
	statuses.update_health(frac_cur_health)
	

func set_score(value: int) -> void:
	score_label.text = str(value)
	score = value
