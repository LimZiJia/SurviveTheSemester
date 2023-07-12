class_name BurnableComponent
extends Node2D

@export var health_component: HealthComponent
@export var hurtbox_component: HurtboxComponent

@export var sprite: CanvasItem
@export var tint_material: ShaderMaterial

var burnt_time := 3.0

var burnable_particles_tween: Tween

@onready var gpu_particles_2d := $GPUParticles2D as GPUParticles2D

func _ready() -> void:
	hurtbox_component.burnt.connect(on_burnt)


func on_burnt(dmg_per_tick: float) -> void:	
	if burnable_particles_tween != null and burnable_particles_tween.is_valid():
		burnable_particles_tween.kill()

	# Material might be overriden by another component manipulating material
	sprite.material = tint_material
	gpu_particles_2d.emitting = true
	
	burnable_particles_tween = create_tween()
	burnable_particles_tween.tween_interval(burnt_time)
	burnable_particles_tween.tween_callback(func():
		gpu_particles_2d.emitting = false)
	
	var burnable_damage_tween := create_tween()
	burnable_damage_tween.set_loops(3)
	burnable_damage_tween.tween_interval(1.0)
	burnable_damage_tween.tween_callback(func(): 
		health_component.damage(dmg_per_tick)
		# Since the material will reset from each damage causing hitflash
		sprite.material = tint_material)
	burnable_damage_tween.finished.connect(func():
		sprite.material = null)

