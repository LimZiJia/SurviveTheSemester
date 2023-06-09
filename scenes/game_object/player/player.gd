class_name Player
extends CharacterBody2D

signal dead

@export var max_health := 100.0

var facing := Vector2.DOWN
var is_damaged = false

@onready var velocity_component = $VelocityComponent as VelocityComponent
@onready var health_component := $HealthComponent as HealthComponent
@onready var health_label := $HealthLabel as Label
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var animation_tree = $AnimationTree as AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready() -> void:
	health_component.damaged.connect(on_health_component_damaged)
	health_component.dead.connect(on_health_component_dead)
	update_health_label()
	debug()
	
func _physics_process(_delta: float) -> void:
	# Movement
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	dir = dir.normalized()
	
	if is_damaged:
		animation_state.travel("Hurt")
	elif dir != Vector2.ZERO:
		facing = dir
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Move/blend_position", dir)
		animation_tree.set("parameters/Hurt/blend_position", dir)
		animation_tree.set("parameters/conditions/idle", false)
		animation_tree.set("parameters/conditions/moving", true)
		animation_state.travel("Move")
		velocity_component.accelerate_in_direction(dir)
	else:
		animation_tree.set("parameters/conditions/idle", true)
		animation_tree.set("parameters/conditions/moving", false)
		animation_state.travel("Idle")
		velocity_component.decelerate()
	velocity_component.move(self)


func update_health_label() -> void:
	health_label.text = str(int(health_component.current_health))


func on_health_component_damaged() -> void:
	update_health_label()
	GameEvents.emit_health_updated(health_component.current_health, health_component.max_health)
	is_damaged = true
	await get_tree().create_timer(0.15).timeout
	is_damaged = false


func on_health_component_dead() -> void:
	dead.emit()


# For Debugging Purposes
@onready var buttons = $Debug/MarginContainer/VBoxContainer
@onready var weapons_manager = $WeaponManager
func debug():
	var weapons = [
		"default_word_weapon",
		"auto_word_weapon",
		"auto_aim_nearest_word_weapon",
		"auto_aim_direct_word_weapon",
	] as Array[String]
	for weapon in weapons:
		var button_instance = Button.new()
		button_instance.text = weapon.capitalize()
		buttons.add_child(button_instance)
		button_instance.pressed.connect(on_button_pressed.bind(weapon))


func on_button_pressed(weapon: String):
	for child in weapons_manager.get_children():
		child.queue_free()
	var weapon_scene = load("res://scenes/weapons/test/%s_controller.tscn" % weapon)
	print(weapon_scene)
	var weapon_instance = weapon_scene.instantiate()
	weapons_manager.add_child(weapon_instance)
