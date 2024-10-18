#extends CharacterBody3D
#
#@export var speed := 4.0
#@export var gravity := 4.0
#@export var jump_force := 3.5
#@export var attack_range := 1.5  # Distance at which the NPC will attack
#@export var run_animation_speed := 2
#@export var run_animation_when_player_is_move := 2.2
#
#@onready var player_body_2 = $"../Guardian"
#@onready var animation = $AnimationNPC
#var angular_speed = 10
#
#func _physics_process(delta: float) -> void:
	## Check the distance to the player
	#var distance_to_player = global_position.distance_to(player_body_2.global_position)
	#print(distance_to_player)
#
	#if distance_to_player <= attack_range:
		#attackNPC()
	#else:
		#moveTowardPlayer(delta)
#
#func moveTowardPlayer(delta):
	## Check if the NPC is currently playing the attack animation
	#if not animation.is_playing() or animation.current_animation != "Standing Melee Attack Backhand":
		## Calculate direction to the player
		#var direction = (player_body_2.global_position - global_position).normalized()
#
		## Set the NPC's velocity in the x and z directions
		#velocity.x = direction.x * speed * 3  # Increase speed for running
		#velocity.z = direction.z * speed * 3
#
		## Make the NPC face the player
		#look_at(global_position - direction, Vector3.UP)
#
		#animation.play("Run", -1, run_animation_speed)
#
		## Apply gravity
		#velocity.y -= gravity * delta
#
		## Move the character
		#move_and_slide()
#
#func attackNPC():
	#if not animation.is_playing() or animation.current_animation != "Standing Melee Attack Backhand":
		#animation.play("Standing Melee Attack Backhand", -1, run_animation_when_player_is_move)


extends CharacterBody3D

@export var speed := 4.0
@export var gravity := 4.0
@export var jump_force := 3.5
@export var attack_range := 2.0  # Distance at which the NPC will attack
@export var run_animation_speed := 2.0
@export var run_animation_when_player_is_move := 2.2

@onready var player_body_2 = $"../Guardian"
@onready var animation = $AnimationNPC
@onready var is_attack = false

var angular_speed = 10


func _physics_process(delta: float) -> void:
	
	if animation.current_animation != "Standing Melee Attack Backhand":
		is_attack = false
		
	print(is_attack)

	var direction = (player_body_2.global_position - global_position).normalized()

	# Make the NPC face the player
	look_at(global_position - direction, Vector3.UP)

	# Check the distance to the player
	var distance_to_player = global_position.distance_to(player_body_2.global_position)
	print(distance_to_player)

	# Get the player script
	var player_script = player_body_2.get_script()

	# Ensure the player script is valid and check if the player is moving
	if player_script and player_body_2.has_method("get_is_moving"):
		var is_player_moving = player_body_2.get_is_moving()

	if distance_to_player <= attack_range:
		print('IF')
		print(distance_to_player)
		attackNPC()
	#elif is_player_moving and (distance_to_player <= 5):
		#print('ELIF')
		#print(distance_to_player)
		#attackNPC()
	elif (!is_attack and distance_to_player > attack_range):
		print('*********')
		print(distance_to_player)
		moveTowardPlayer(delta)

func moveTowardPlayer(delta):
	# Check if the NPC is currently playing the attack animation
	#if animation.is_playing() and animation.current_animation == "Standing Melee Attack Backhand":
		# Cancel the attack animation if the player is out of range
		#animation.stop()
	var direction = (player_body_2.global_position - global_position).normalized()

	# Set the NPC's velocity in the x and z directions
	velocity.x = direction.x * speed * 3  # Increase speed for running
	velocity.z = direction.z * speed * 3

	animation.play("Run", -1, run_animation_speed)

	# Apply gravity
	velocity.y -= gravity * delta

	# Move the character
	move_and_slide()

func attackNPC():
	# Check if the attack animation is not currently playing
	if not animation.is_playing(): # or animation.current_animation != "Standing Melee Attack Backhand":
		animation.play("Standing Melee Attack Backhand", -1, run_animation_when_player_is_move)
		is_attack = true
