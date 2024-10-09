extends CharacterBody3D

@export var speed := 4.0
@export var gravity := 4.0
@export var jump_force := 7.0

@onready var player_body = $Armature
@onready var anim = $AnimationPlayer

var angular_speed = 10

var movement
var direction

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta):
	movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(movement.x, 0, movement.y)).normalized()

	if direction:
		anim.play("Armature|Armature|Walking")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(velocity.x, velocity.z), delta * angular_speed)
	else:
		anim.play("Armature|Armature|neutral idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()
