extends Node2D

const GRADE_BOUNDARIES := [
	95, 90, 85, 50, 75, 60, 50, 40, 30, 20, 0
]

@onready var health_bar := $HealthBar as TextureProgressBar
@onready var health_grade := $HealthBar/Grade as Sprite2D

func update_health(frac_cur_health: float) -> void:
	health_bar.value = int(frac_cur_health * 100)
	update_grades(frac_cur_health * 100)


func update_grades(percent: float) -> void:
	for i in GRADE_BOUNDARIES.size():
		if percent >= GRADE_BOUNDARIES[i]:
			health_grade.frame = i
			break
