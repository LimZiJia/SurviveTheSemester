extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_stats(damage: float, knockback: float, crit_multiplier: float, crit_chance: float) -> void:
	for sniplet in $Visuals.get_children():
		var hitbox_component = sniplet.get_children()[0] as HitboxComponent
		if hitbox_component == null:
			continue
		
		hitbox_component.damage = damage
		hitbox_component.knockback_force = knockback
		hitbox_component.crit_multiplier = crit_multiplier
		hitbox_component.crit_chance = crit_chance

func start_typing_sound() -> void:
	AudioManager.play_audio("typing", 7.0)
