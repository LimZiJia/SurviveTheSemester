extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_damage_knockback(damage: float, knockback: float) -> void:
	$Visuals/Sniplet_0/HitboxComponent.damage = damage
	$Visuals/Sniplet_1/HitboxComponent.damage = damage
	$Visuals/Sniplet_2/HitboxComponent.damage = damage
	$Visuals/Sniplet_3/HitboxComponent.damage = damage
	$Visuals/Sniplet_4/HitboxComponent.damage = damage
	$Visuals/Sniplet_5/HitboxComponent.damage = damage
	$Visuals/Sniplet_6/HitboxComponent.damage = damage
	$Visuals/Sniplet_7/HitboxComponent.damage = damage
	$Visuals/Sniplet_8/HitboxComponent.damage = damage
	$Visuals/Sniplet_9/HitboxComponent.damage = damage
	$Visuals/Sniplet_10/HitboxComponent.damage = damage
	$Visuals/Sniplet_11/HitboxComponent.damage = damage
	
	$Visuals/Sniplet_0/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_1/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_2/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_3/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_4/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_5/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_6/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_7/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_8/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_9/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_10/HitboxComponent.knockback_force = knockback
	$Visuals/Sniplet_11/HitboxComponent.knockback_force = knockback

func start_typing_sound() -> void:
	GameEvents.emit_sound_made("typing", 0.0, 1.0)
