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
var min_distance: float = -1.0
var max_distance: float = 10.0
var current_distance: float = 5.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	# Keep the camera at a fixed distance from the player
	var target_position = player.position + transform.basis.z * current_distance
	position = target_position

func _input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#rotate_camera(p_event.relative)
		#get_viewport().set_input_as_handled()
		return

	if p_event is InputEventMouseButton:
		# Handle mouse wheel input for zooming
		if p_event.button_index == MOUSE_BUTTON_WHEEL_UP and p_event.pressed:
			current_distance = clamp(current_distance - zoom_speed, min_distance, max_distance)
		elif p_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and p_event.pressed:
			current_distance = clamp(current_distance + zoom_speed, min_distance, max_distance)

func rotate_camera(p_relative: Vector2) -> void:
	_camera_yaw.rotation.y -= p_relative.x * mouse_sensitivity
	_camera_yaw.orthonormalize()

	_camera_pitch.rotation.x += p_relative.y * mouse_sensitivity * CAMERA_RATIO * mouse_y_inversion 
	_camera_pitch.rotation.x = clamp(_camera_pitch.rotation.x, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)
