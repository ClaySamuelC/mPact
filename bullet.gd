extends Area2D

var direction: Vector2
@export var speed: float = 700

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_timer_timeout():
	queue_free()
