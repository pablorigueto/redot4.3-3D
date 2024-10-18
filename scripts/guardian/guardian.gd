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
var is_moving: bool = false

func get_is_moving() -> bool:
	return is_moving

func _physics_process(delta: float) -> void:
	move(delta)
	#print('is_moving: ' + str(is_moving))
	
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
			is_moving = true

			# Check if the Shift key is pressed
			if Input.is_action_pressed("ui_shift"):  # Ensure you set this action in the Input Map
				anim.play("Run", -1, run_animation_speed)
				velocity.x = direction.x * speed * 3  # Increase speed for running
				velocity.z = direction.z * speed * 3
			else:
				is_moving = false
				anim.play("Walk")
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed

			player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(velocity.x, velocity.z), delta * angular_speed)
		else:
			is_moving = false
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

func _input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseButton:
		if p_event.button_index == MOUSE_BUTTON_LEFT and p_event.pressed:
			var mouse_pos = get_viewport().get_mouse_position()
			var camera = %Camera3D

			# Get the ray from the camera
			var ray_origin = camera.project_ray_origin(mouse_pos)
			var ray_direction = camera.project_ray_normal(mouse_pos)

			# Create a PhysicsRayQueryParameters3D object
			var ray_parameters = PhysicsRayQueryParameters3D.new()
			ray_parameters.from = ray_origin
			ray_parameters.to = ray_origin + ray_direction * 1000  # Adjust the distance as needed

			# Perform the raycast
			var space_state = get_world_3d().direct_space_state
			var result = space_state.intersect_ray(ray_parameters)

			if result:
				var hit_position = result.position
				print("Hit Position: ", hit_position)  # Print the position where the ray hit an object
				print("Hit Object: ", result.collider)  # Print the collider that was hit

				# Calculate and print the distance from the player to the hit position
				var player_position = player_body.global_transform.origin
				var distance = player_position.distance_to(hit_position)
				print("Distance to Mouse Click: ", distance)
