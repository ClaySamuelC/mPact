extends Node

@onready var cd_timer = $CooldownTimer
@onready var caster = get_parent()

@export var cd: float = 1.0

var is_on_cooldown: bool = false

func _ready() -> void:
	cd_timer.wait_time = cd

func cast(target_position: Vector2) -> void:
	if is_on_cooldown:
		return
	
	_on_cast(target_position)
	
	is_on_cooldown = true
	cd_timer.start()

func _on_cast(target_position: Vector2) -> void:
	pass
