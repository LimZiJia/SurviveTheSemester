extends Node2D

var grade_arr:Array = [
	preload("res://assets/A+.png"),
	preload("res://assets/A.png"),
	preload("res://assets/B.png"),
	preload("res://assets/C.png"),
	preload("res://assets/D.png"),
	preload("res://assets/F.png")
]

@onready var health_bar = $HealthBar
@onready var health_grade = $HealthBar/Grade

func update_health(frac_cur_health: float) -> void:
	health_bar.value = int(frac_cur_health * 100)
	update_grades(frac_cur_health * 100)


func update_grades(percent: float) -> void:
	if (percent >= 90):
		health_grade.texture = grade_arr[0]
	elif (percent >= 80):
		health_grade.texture = grade_arr[1]
	elif (percent >= 70):
		health_grade.texture = grade_arr[2]
	elif (percent >= 60):
		health_grade.texture = grade_arr[3]
	elif (percent >= 50):
		health_grade.texture = grade_arr[4]
	else:
		health_grade.texture = grade_arr[5]
