extends Node3D

const CAMERA_MAX_PITCH: float = deg_to_rad(70)
const CAMERA_MIN_PITCH: float = deg_to_rad(-89.9)
const CAMERA_RATIO: float = 0.625

@export var mouse_sensitivity: float = 0.002
@export var mouse_y_inversion: float = -0.5

@onready var player = $"../Guardian"
@onready var _camera_yaw: Node3D = self
@onready var _camera_pitch: Node3D = $Camera3D  # Ensure the path is correct

# Zoom parameters
var zoom_speed: float = 0.1
var min_distance: float = 5.0
var max_distance: float = 12.0
var current_distance: float = 8.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_camera_yaw.rotation.y = 0
	_camera_pitch.rotation.x = 0

func _process(delta: float) -> void:
	# Keep the camera at a fixed distance from the player
	var target_position = player.position + transform.basis.z * current_distance
	position = target_position

func _input(p_event: InputEvent) -> void:
	print(current_distance)
	if current_distance <= 6.5:
		if p_event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_camera(p_event.relative)
			get_viewport().set_input_as_handled()
			return
	elif current_distance >= 6.6 and current_distance <= 7.0:
		reset_camera()

	if p_event is InputEventMouseButton:
		# Handle mouse wheel input for zooming
		if p_event.button_index == MOUSE_BUTTON_WHEEL_UP and p_event.pressed:
			current_distance = clamp(current_distance - zoom_speed, min_distance, max_distance)
		elif p_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and p_event.pressed:
			current_distance = clamp(current_distance + zoom_speed, min_distance, max_distance)

	# Check for Ctrl + Enter to toggle fullscreen
	if p_event is InputEventKey:
		if p_event.pressed:  # Only check when the key is pressed
			if p_event.key_code == Key.KEY_ENTER:
				toggle_fullscreen()

func reset_camera() -> void:
	# Get current rotations
	var current_yaw = _camera_yaw.rotation.y
	var current_pitch = _camera_pitch.rotation.x

	# Set target rotations
	var target_yaw = 0.0
	var target_pitch = 0.0

	# Duration for the transition
	var duration = 1.0  # Adjust this for your desired speed
	var frames = int(duration * 60)  # Assuming 60 FPS

	# Smoothly transition to the target rotations over time
	for t in range(frames + 1):  # Include the final value
		var alpha = t / float(frames)  # Normalized time (0 to 1)
		_camera_yaw.rotation.y = lerp(current_yaw, target_yaw, alpha)
		_camera_pitch.rotation.x = lerp(current_pitch, target_pitch, alpha)

		await get_tree().create_timer(1 / 60).timeout  # Wait for next frame

	# Ensure final values are set
	_camera_yaw.rotation.y = target_yaw
	_camera_pitch.rotation.x = target_pitch

func rotate_camera(p_relative: Vector2) -> void:
	_camera_yaw.rotation.y -= p_relative.x * mouse_sensitivity
	_camera_yaw.orthonormalize()

	_camera_pitch.rotation.x += p_relative.y * mouse_sensitivity * CAMERA_RATIO * mouse_y_inversion 
	_camera_pitch.rotation.x = clamp(_camera_pitch.rotation.x, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)

func toggle_fullscreen() -> void:
	var viewport = get_viewport()

	if viewport.fullscreen:
		viewport.fullscreen = false  # Exit fullscreen
		viewport.borderless = false    # Optionally restore windowed mode
	else:
		viewport.fullscreen = true    # Enter fullscreen
