extends Area2D

const SPEED = 500.0

var velocity
# Get the gravity from the project settings to be synced with RigidBody nodes.
var direction : Vector2

func _ready():
	direction = Vector2(1,0).rotated(rotation)

func _physics_process(delta):
	# Add the gravity.
	velocity = SPEED * direction
	self.translate(velocity * delta) 

func _on_body_entered(body: Node2D) -> void:
		if self != body:
			print("pikle")
