extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_damage_knockback(damage: float, knockback: float) -> void:
	$Sniplet_0/HitboxComponent.damage = damage
	$Sniplet_1/HitboxComponent.damage = damage
	$Sniplet_2/HitboxComponent.damage = damage
	$Sniplet_3/HitboxComponent.damage = damage
	$Sniplet_4/HitboxComponent.damage = damage
	$Sniplet_5/HitboxComponent.damage = damage
	$Sniplet_6/HitboxComponent.damage = damage
	$Sniplet_7/HitboxComponent.damage = damage
	$Sniplet_8/HitboxComponent.damage = damage
	
	$Sniplet_0/HitboxComponent.knockback_force = knockback
	$Sniplet_1/HitboxComponent.knockback_force = knockback
	$Sniplet_2/HitboxComponent.knockback_force = knockback
	$Sniplet_3/HitboxComponent.knockback_force = knockback
	$Sniplet_4/HitboxComponent.knockback_force = knockback
	$Sniplet_5/HitboxComponent.knockback_force = knockback
	$Sniplet_6/HitboxComponent.knockback_force = knockback
	$Sniplet_7/HitboxComponent.knockback_force = knockback
	$Sniplet_8/HitboxComponent.knockback_force = knockback
