extends CharacterBody2D


const SPEED = 300.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var syncPos = Vector2(0,0)
var syncRot = 0
@export var bullet :PackedScene

func _ready():
	add_to_group("baddies")
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		$GunRotation.look_at(get_viewport().get_mouse_position())
		
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
	else:
		global_position = global_position.lerp(syncPos, .5)
		rotation_degrees = lerpf(rotation_degrees, syncRot, .5)

@rpc("any_peer","call_local")
func fire():
	var b = bullet.instantiate()
	b.global_position = $GunRotation/BulletSpawn.global_position
	b.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(b)
