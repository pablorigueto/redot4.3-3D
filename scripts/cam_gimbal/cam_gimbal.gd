extends Node3D


@onready var player = $"../Player-elf-archer"
var base_position = Vector3()
var base_rotation = Vector3()

func _ready() -> void:
	base_position = position
	base_rotation = rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = player.position
