extends Node3D

var ray_origin := Vector3()
var ray_target := Vector3()
	
@onready var player: CharacterBody3D = $Player
@onready var camera_3d: Camera3D = $Camera3D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
