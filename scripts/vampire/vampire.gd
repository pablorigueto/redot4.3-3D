
extends CharacterBody3D

@export var speed := 4.0
@export var gravity := 4.0
@export var jump_force := 3.5
@export var attack_range := 2.0  # Distance at which the NPC will attack

@onready var player_body_2 = $"../Guardian" 
@onready var animation = $AnimationNPC
var angular_speed = 10

func _physics_process(delta: float) -> void:
	# Check the distance to the player
	var distance_to_player = global_position.distance_to(player_body_2.global_position)
	print(distance_to_player)

	if distance_to_player <= attack_range:
		attackNPC()
	else:
		moveTowardPlayer(delta)

func moveTowardPlayer(delta):
	# Calculate direction to the player
	var direction = (player_body_2.global_position - global_position).normalized()

	# Set the NPC's velocity in the x and z directions
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Make the NPC face the player
	look_at(global_position - direction, Vector3.UP)

	animation.play("Run")

	# Apply gravity
	velocity.y -= gravity * delta

	# Move the character
	move_and_slide()

func attackNPC():
	animation.play("Standing Melee Attack Backhand")
	# You can also add any attack logic here, if needed
