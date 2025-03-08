extends CharacterBody2D

var startingHealth = 100
var currentHealth = startingHealth

var startingDamage = 1
var currentDamage = startingDamage

const SPEED = 300.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var syncPos = Vector2(0,0)
var syncRot = 0
var uninteruptable_animations = ["attack","attack_Left","charging"]
var left = false
@onready var animationPlayer = $AnimationPlayer

var chargeTick = 0
var chargeTickTimer = 20

func _ready():
	add_to_group("baddies")
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	charge_up()
	handle_flipping()
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		syncPos = global_position
		syncRot = rotation_degrees
		if Input.is_action_just_pressed("Fire"):
			fire.rpc()
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		var direction_updown = Input.get_axis("ui_up", "ui_down")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if direction_updown:
			velocity.y = direction_updown * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		move_and_slide()
		if uninteruptable_animations.find(animationPlayer.current_animation) == -1 :
			if velocity.x != 0 or velocity.y != 0:
				animationPlayer.play("run")
			else:
				animationPlayer.play("idle")
	else:
		global_position = global_position.lerp(syncPos, .5)
		rotation_degrees = lerpf(rotation_degrees, syncRot, .5)

@rpc("any_peer","call_local")
func fire():
	if uninteruptable_animations.find(animationPlayer.current_animation) == -1 :
		if left:
			animationPlayer.play("attack_Left")
			animationPlayer.queue("idle")
		else:
			animationPlayer.play("attack")
			animationPlayer.queue("idle")
		pass

func takeDamage(damage: int):
	currentHealth -= damage
	if currentHealth < 0:
		print("I dieeeed")
	pass

func _on_axe_area_body_entered(body: Node2D) -> void:
	if body != self:
		body.takeDamage(currentDamage)
		print("you've been hit")
	pass # Replace with function body.

func handle_flipping():
	if Input.is_action_just_pressed("ui_left"):
		left = true
		$CollisionShape2D/Orc.flip_h = true
	if Input.is_action_just_pressed("ui_right"):
		left = false
		$CollisionShape2D/Orc.flip_h = false

func charge_up():
	if Input.is_action_pressed("Charge"):#TODO Replace with charge
		animationPlayer.play("charging")
		animationPlayer.queue("idle")
		chargeTick += 1
		if chargeTick >= chargeTickTimer:
			currentDamage += 1
			chargeTick = 0
			self.scale += Vector2(.2,.2)
	#if tick = tick_timer damage += 1 scale = scale +.5
