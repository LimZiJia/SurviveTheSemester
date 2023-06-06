extends Node2D

@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var blood := $BloodOverlay as TextureRect
@onready var red := $RedRect as ColorRect

var prev_health:float = Global.health
var b_final_a = 80
var r_final_a = 35

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Global.health != prev_health):
		# Flashing animation
		if (Global.health < prev_health):
			var inv_ratio = 1 - (Global.health / Global.max_health)
			var cur_blood_a = b_final_a * inv_ratio if inv_ratio > .5 else 0
			var cur_red_a = r_final_a * inv_ratio if inv_ratio > .5 else 0
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

	prev_health = Global.health
	
	
