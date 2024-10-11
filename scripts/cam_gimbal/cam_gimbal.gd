#extends Node3D
#
#@onready var player = $"../Guardian"
#var base_position = Vector3()
#var base_rotation = Vector3()
#
## Zoom parameters
#var zoom_speed: float = 5.0
#var min_distance: float = -1.8
#var max_distance: float = 5.0
#var current_distance: float = 1.0
#
#func _ready() -> void:
	#base_position = position
	#base_rotation = rotation
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#position = player.position
#
	#if Input.is_action_pressed('cam_rotation_left'):
		#rotation.y += 1.0 * delta
	#
	#if Input.is_action_pressed('cam_rotation_right'):
		#rotation.y -= 1.0 * delta
		#
	#if Input.is_action_pressed('cam_gimbal_up'):
		#rotation.y -= 1.0 * delta
		#rotation.x -= 0.3 * delta
		#
	#if Input.is_action_pressed('cam_gimbal_down'):
		#rotation.y += 1.0 * delta
		#rotation.x += 0.3 * delta
		#
	#if Input.is_action_just_pressed("rotate_cam"):
		#rotation_degrees.y += 90
#
	## Handle zooming
	#if Input.is_action_pressed('zoom_in'):
		#current_distance = clamp(current_distance - zoom_speed * delta, min_distance, max_distance)
	#elif Input.is_action_pressed('zoom_out'):
		#current_distance = clamp(current_distance + zoom_speed * delta, min_distance, max_distance)
#
	## Update position based on zoom
	#position = player.position + transform.basis.z * current_distance

#
#extends Node3D
#
#@onready var player = $"../Guardian"
#var base_position = Vector3()
#var base_rotation = Vector3()
#
## Zoom parameters
#var zoom_speed: float = 5.0
#var min_distance: float = -1.8
#var max_distance: float = 5.0
#var current_distance: float = 1.0
#
## Mouse sensitivity
#var mouse_sensitivity: float = 0.1
#
#func _ready() -> void:
	#base_position = position
	#base_rotation = rotation
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#position = player.position
#
	## Get mouse motion
	#var mouse_motion = Input.get_last_mouse_velocity()
#
	## Rotate the camera based on mouse movement
	#rotation.y -= mouse_motion.x * mouse_sensitivity
	#rotation.x -= mouse_motion.y * mouse_sensitivity
	#
	## Clamp the vertical rotation to prevent flipping
	#rotation.x = clamp(rotation.x, deg_to_rad(-89), deg_to_rad(89))
#
	## Handle zooming
	#if Input.is_action_pressed('zoom_in'):
		#current_distance = clamp(current_distance - zoom_speed * delta, min_distance, max_distance)
	#elif Input.is_action_pressed('zoom_out'):
		#current_distance = clamp(current_distance + zoom_speed * delta, min_distance, max_distance)
#
	## Update position based on zoom
	#position = player.position + transform.basis.z * current_distance
extends Node3D

const CAMERA_MAX_PITCH: float = deg_to_rad(70)
const CAMERA_MIN_PITCH: float = deg_to_rad(-89.9)
const CAMERA_RATIO: float = 0.625
@export var MOVE_SPEED: float = 50.0

@export var mouse_sensitivity: float = 0.002
@export var mouse_y_inversion: float = -1.0

@onready var player = $"../Guardian"
@onready var _camera_yaw: Node3D = self
@onready var _camera_pitch: Node3D = $Camera3D  # Adjust this to your actual camera node

# Zoom parameters
var zoom_speed: float = 1.0  # Adjust this to control zoom speed with mouse wheel
var min_distance: float = -2.8
var max_distance: float = 5.0
var current_distance: float = 1.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	position = player.position

	# Update position based on zoom
	position = player.position + transform.basis.z * current_distance

func _input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_camera(p_event.relative)
		get_viewport().set_input_as_handled()

	if p_event is InputEventMouseButton:
		# Handle mouse wheel input for zooming
		if p_event.button_index == MOUSE_BUTTON_WHEEL_UP and p_event.pressed:  # 4 is WHEEL_UP
			current_distance = clamp(current_distance - zoom_speed, min_distance, max_distance)
		elif p_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and p_event.pressed:  # 5 is WHEEL_DOWN
			current_distance = clamp(current_distance + zoom_speed, min_distance, max_distance)

func rotate_camera(p_relative: Vector2) -> void:
	_camera_yaw.rotation.y -= p_relative.x * mouse_sensitivity
	_camera_yaw.orthonormalize()
	_camera_pitch.rotation.x += p_relative.y * mouse_sensitivity * CAMERA_RATIO * mouse_y_inversion
	_camera_pitch.rotation.x = clamp(_camera_pitch.rotation.x, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)
