extends CharacterBody3D
class_name Player

@onready var body: MeshInstance3D = $Body
@onready var aimer: Node3D = $aimer
@onready var camera_3d: Camera3D = $Camera3D

@export var camera_position: Vector3 = Vector3(0, 20, 5)
@export var camera_offset: int = 0


@export var speed = 5.0
@export var accel = 2.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	
	

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction: Vector2 = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.z = move_toward(velocity.z, speed * direction.y, accel)

	move_and_slide()
	
	
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2000
	var from = camera_3d.project_ray_origin(mouse_pos)
	var to = from + camera_3d.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	
	if not raycast_result.is_empty():
		var pos = raycast_result.position
		var look_at_me = Vector3(pos.x, position.y, pos.z)
		aimer.look_at(look_at_me, Vector3.UP)
		if Input.is_action_pressed("aim"):
			look_at(look_at_me, Vector3.UP)
		camera_3d.position.x = (lerp(global_position.x, pos.x, .2))
		camera_3d.position.z = (lerp(global_position.z, pos.z, .3)) + camera_offset
