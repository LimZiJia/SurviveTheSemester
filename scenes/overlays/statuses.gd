extends Node2D

const GRADE_BOUNDARIES := [
	95, 90, 85, 50, 75, 60, 50, 40, 30, 20, 0
]

@onready var health_bar := $HealthBar as TextureProgressBar
@onready var health_grade := $HealthBar/Grade as Sprite2D


func _ready() -> void:
	GameEvents.health_damaged.connect(on_health_updated)
	GameEvents.health_healed.connect(on_health_updated)


func on_health_updated(current_health: float, max_health: float) -> void:
	update_health_bar(current_health / max_health)
	update_grades(current_health / max_health * 100)


func update_health_bar(frac_cur_health: float) -> void:
	health_bar.value = int(frac_cur_health * 100)


func update_grades(percent: float) -> void:
	for i in GRADE_BOUNDARIES.size():
		if percent >= GRADE_BOUNDARIES[i]:
			health_grade.frame = i
			break
