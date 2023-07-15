extends CharacterBody2D

var money: int = 0

@onready var despawn_animation_player := $DespawnAnimationPlayer as AnimationPlayer
@onready var velocity_component := $VelocityComponent as VelocityComponent

var player_detected := false

func _ready() -> void:
	$DespawnTimer.timeout.connect(on_despawn_timer_timeout)
	$PlayerDetectArea2D.body_entered.connect(on_player_detect_area_body_entered)
	$PlayerDetectArea2D.body_exited.connect(on_player_detect_area_body_exited)
	$PlayerCollectArea2D.body_entered.connect(on_player_collect_area_body_entered)


func _physics_process(_delta: float) -> void:
	if player_detected:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	velocity_component.move(self)


func on_despawn_timer_timeout() -> void:
	despawn_animation_player.play("despawn")


func on_player_detect_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_detected = true


func on_player_detect_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_detected = false


func on_player_collect_area_body_entered(body: Node2D) -> void:
	if body is Player:
		drop_money()


func drop_money() -> void:
	GameEvents.emit_money_collected(money)
	GameEvents.emit_sound_made("pick_up_coin", -12.0, 1.0)
	queue_free()
