extends CharacterBody2D

var bullet_scene = preload("res://bullet.tscn")

# Movement speed (pixels per second)
@export var speed: float = 200.0
@export var shoot_cooldown: float = 0.5

@onready var barrel = $Barrel
@onready var shoot_timer = $ShootCooldown

# Velocity vector
var movement: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	movement = Vector2.ZERO

	# Check for input and update movement
	velocity.x = Input.get_axis("left", "right") * speed
	velocity.y = Input.get_axis("up", "down") * speed

	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		if !shoot_timer.time_left > 0:
			shoot_timer.start(shoot_cooldown)
			
			var bullet = bullet_scene.instantiate()
			bullet.global_position = barrel.global_position
			bullet.direction = (get_global_mouse_position() - global_position).normalized()
			
			$/root/mpact.add_child(bullet)
