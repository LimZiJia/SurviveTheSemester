extends Node2D

@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var blood := $BloodOverlay as TextureRect
@onready var red := $RedRect as ColorRect

var prev_health:float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Global.health != prev_health):
		# Flashing animation
		if (Global.health < prev_health):	
			animation.play("flash")
			await(animation.animation_finished)
			
			# Bloody screen when little health
			if (Global.health / Global.max_health < .25):
				blood.modulate.a8 = 40
				red.modulate.a8 = 30
			elif (Global.health / Global.max_health < .5):
				blood.modulate.a8 = 20
				red.modulate.a8 = 20
	
	prev_health = Global.health
	
	
