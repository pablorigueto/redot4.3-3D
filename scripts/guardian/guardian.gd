extends CharacterBody3D

@export var speed := 4.0
@export var gravity := 4.0
@export var jump_force := 7.0

@onready var player_body = $Armature
@onready var anim = $AnimationPlayer
@onready var camera = $"../cam_gimbal"
var angular_speed = 10

var movement
var direction

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta):
	movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#direction = (transform.basis * Vector3(movement.x, 0, movement.y)).normalized()
	direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, camera.rotation.y).normalized()
	
	if direction:
		anim.play("Walk")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(velocity.x, velocity.z), delta * angular_speed)
	else:
		anim.play("Idle Regular")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_force
		#anim.play("Sword And Shield Jump")

	velocity.y -= gravity * delta

	move_and_slide()
