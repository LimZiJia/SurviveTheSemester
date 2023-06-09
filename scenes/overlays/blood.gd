extends Node2D

@onready var blood := $BloodOverlay as TextureRect
@onready var red := $RedRect as ColorRect

var b_final_a = 80
var r_final_a = 35


func _ready() -> void:
	GameEvents.health_healed.connect(on_health_healed)
	GameEvents.health_damaged.connect(on_health_damaged)


func on_health_healed(current_health: float, max_health: float) -> void:
	play_healed_overlay(current_health / max_health)


func on_health_damaged(current_health: float, max_health: float) -> void:
	play_damaged_overlay(current_health / max_health)


func play_healed_overlay(frac_cur_health: float) -> void:
	var inv_ratio = 1 - frac_cur_health
	var cur_blood_a = b_final_a * inv_ratio if inv_ratio > 0.5 else 0.0
	var cur_red_a = r_final_a * inv_ratio if inv_ratio > 0.5 else 0.0
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(blood, "modulate", \
		Color8(255, 255, 255, int(cur_blood_a)), 0.15)
	tween.tween_property(red, "modulate", \
		Color8(255, 255, 255, int(cur_red_a)), 0.15)


func play_damaged_overlay(frac_cur_health: float) -> void:
	var inv_ratio = 1 - frac_cur_health
	var cur_blood_a = b_final_a * inv_ratio if inv_ratio > 0.5 else 0.0
	var cur_red_a = r_final_a * inv_ratio if inv_ratio > 0.5 else 0.0
	var tween1 = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween1.tween_property(blood, "modulate", \
		Color8(255, 255, 255, int(cur_blood_a * 1.1) + 30), 0.1)
	tween2.tween_property(red, "modulate", \
		Color8(255, 255, 255, int(cur_red_a * 1.1) + 15), 0.1)
	
	tween1.tween_property(blood, "modulate", \
		Color8(255, 255, 255, int(cur_blood_a)), 0.15)
	tween2.tween_property(red, "modulate", \
		Color8(255, 255, 255, int(cur_red_a)), 0.15)
