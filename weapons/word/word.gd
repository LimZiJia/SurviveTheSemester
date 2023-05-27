extends Node2D

@export var WORD_PROJECTILE_SCENE: PackedScene
@export_range(0.05, 10, 0.05) var cooldown := 0.05
var can_attack := true
@onready var cooldown_timer = $CooldownTimer


func _ready():
	cooldown_timer.timeout.connect(_on_cooldown)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()


func attack() -> void:
	if not can_attack:
		return
	var mob = find_nearest_mob()
	if not mob:
		return
	
	can_attack = false
	cooldown_timer.start(cooldown)
	
	var word_projectile := WORD_PROJECTILE_SCENE.instantiate()
	word_projectile.position = global_position
	word_projectile.direction = global_position.direction_to(mob.global_position)
	add_child(word_projectile)


func _on_cooldown() -> void:
	can_attack = true


func find_nearest_mob():
	var mobs = get_tree().get_nodes_in_group("mobs")
	var nearest = null
	var cur_dist = INF
	for mob in mobs:
		var dist = global_position.distance_to(mob.global_position)
		if dist < cur_dist:
			nearest = mob
			cur_dist = dist
	return nearest
