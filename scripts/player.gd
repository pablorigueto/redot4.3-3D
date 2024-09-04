extends CharacterBody3D

# Declare constants for speed, jump velocity, and a target position.
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var target_position : Vector3 = Vector3()  # Initialize to a default Vector3 value
var animation_player : AnimationPlayer

# Initialize the animation player.
func _ready() -> void:
	# Ensure that the AnimationPlayer node is properly assigned.
	animation_player = $"player-warrior/AnimationPlayer"
	if not animation_player:
		push_error("AnimationPlayer node not found. Ensure that it is correctly assigned as a child of this node.")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# If there's a target position, move towards it.
	if target_position:
		var direction = (target_position - global_transform.origin).normalized()
		if direction.length() > 0:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			# Play the running animation if not already playing.
			if animation_player and not animation_player.is_playing():
				animation_player.play("running")
		else:
			# Stop the animation if reached the target.
			if animation_player:
				animation_player.stop()
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		move_and_slide()
	else:
		# Stop the animation if no target position is set.
		if animation_player:
			animation_player.stop()

# Detect mouse click and set the target position.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_position = event.position
		var camera = get_viewport().get_camera_3d()
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_direction = camera.project_ray_normal(mouse_position)
		
		var space_state = get_world_3d().direct_space_state
		var ray_end = ray_origin + ray_direction * 1000  # Define the end point of the ray
		var params = PhysicsRayQueryParameters3D.new()
		params.from = ray_origin
		params.to = ray_end
		
		var result = space_state.intersect_ray(params)
		
		if result:
			target_position = result.position
