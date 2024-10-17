#extends CharacterBody3D
#
#@export var speed := 4.0
#@export var gravity := 4.0
#@export var jump_force := 3.5
#@export var run_animation_speed := 2
#
#@onready var player_body = $Armature
#@onready var anim = $AnimationPlayer
#@onready var camera = $"../cam_gimbal"
#var angular_speed = 10
#
#var movement
#var direction
#var is_jumping = false
#
#func _physics_process(delta: float) -> void:
	#move(delta)
	#
#func move(delta):
	#movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, camera.rotation.y).normalized()
#
	#if is_on_floor():
#
		#if is_jumping:
			#is_jumping = false  # Reset jumping state after landing
#
		## Handle movement and play appropriate animations
		#if direction:
			## Check if the Shift key is pressed
			#if Input.is_action_pressed("ui_shift"):  # Ensure you set this action in the Input Map
				##anim.play("Run")  # Play the running animation
				#anim.play("Run", -1, run_animation_speed)
				#velocity.x = direction.x * speed * 3  # Increase speed for running
				#velocity.z = direction.z * speed * 3
			#else:
				#anim.play("Walk")  # Play the walking animation
				#velocity.x = direction.x * speed
				#velocity.z = direction.z * speed
#
			#player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(velocity.x, velocity.z), delta * angular_speed)
		#else:
			#anim.play("Idle Regular")
			#velocity.x = move_toward(velocity.x, 0, speed)
			#velocity.z = move_toward(velocity.z, 0, speed)
#
	## Handle jumping
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#is_jumping = true
		#velocity.y = jump_force  # Set jump force immediately
		##anim.play("Sword And Shield Jump", jump_animation_speed)
		#anim.play("Sword And Shield Jump")
#
	## Apply gravity
	#velocity.y -= gravity * delta
#
	## Move the character
	#move_and_slide()
#
#
#
## Just to know about it.
##if anim.current_animation != "Sword And Shield Jump":


extends CharacterBody3D

@export var speed := 4.0
@export var gravity := 4.0
@export var jump_force := 3.5
@export var run_animation_speed := 2

@onready var player_body = $Armature
@onready var anim = $AnimationPlayer
@onready var camera = $"../cam_gimbal"
var angular_speed = 10

var movement
var direction
var is_jumping = false
var target_direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta):
	movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Calculate direction from keyboard input
	var keyboard_direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, camera.rotation.y).normalized()
	
	# Combine keyboard direction with target direction (mouse click)
	if target_direction != Vector3.ZERO:
		direction = target_direction.normalized()
	else:
		direction = keyboard_direction
	
	if is_on_floor():
		if is_jumping:
			is_jumping = false  # Reset jumping state after landing

		# Handle movement and play appropriate animations
		if direction:
			# Check if the Shift key is pressed
			if Input.is_action_pressed("ui_shift"):  # Ensure you set this action in the Input Map
				anim.play("Run", -1, run_animation_speed)
				velocity.x = direction.x * speed * 3  # Increase speed for running
				velocity.z = direction.z * speed * 3
			else:
				anim.play("Walk")
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed

			player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(velocity.x, velocity.z), delta * angular_speed)
		else:
			anim.play("Idle Regular")
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		is_jumping = true
		velocity.y = jump_force
		anim.play("Sword And Shield Jump")

	# Apply gravity
	velocity.y -= gravity * delta

	# Move the character
	move_and_slide()


# Detect mouse clicks to move the player
# func _input(event):
# 	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
# 		var mouse_position = event.position

# 		# Get the Camera3D from the Node3D
# 		var camera_node = %Camera3D
# 		if camera_node is Camera3D:
# 			var ray_origin = camera_node.project_ray_origin(mouse_position)
# 			var ray_direction = camera_node.project_ray_normal(mouse_position)

# 			# Create RayCastParameters
# 			var params = RayCastParameters.new()
# 			params.from = ray_origin
# 			params.to = ray_origin + ray_direction * 1000
			
# 			# Cast a ray to get the point on the ground
# 			var space_state = get_world_3d().direct_space_state
# 			var result = space_state.intersect_ray(params)

# 			if result and result.has("position"):
# 				target_direction = (result.position - global_transform.origin).normalized()
# 			else:
# 				target_direction = Vector3.ZERO


# Using Godot 4.3 and GDScript I want to move my player when he clicked on the map,
# I already have the move using "ui_left", "ui_right", "ui_up" and "ui_down", but now I want to move the player using the mouse cursor, PLEASE KEEP BOTH way to move the player.

# my current code:
