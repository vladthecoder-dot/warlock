extends CharacterBody3D
class_name PlayerCharacter

@export_category("Movement")
@export var walking_speed: float = 5.0
@export var jump_velocity: float = 4.5

@export_category("Camera")
@export var camera_sensitivity: float = 0.003
@export var target_max_distance = 1000
@export_custom(PROPERTY_HINT_NONE, "suffix:º") var min_tilt: float= -90.0
@export_custom(PROPERTY_HINT_NONE, "suffix:º") var max_tilt: float = 90.0
var camera_pitch: float = 0.0
@onready var player_camera: Camera3D = $PlayerCamera

@onready var invoker: Invoker = $Invoker
@onready var invocation_holder: Marker3D = $PlayerCamera/InvocationHolder
@onready var invocation_menu : Control = $Invoker/InvocationMenu

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	invocation_menu.visibility_changed.connect(func(): 
		switch_mouse_mode(invocation_menu.visible))

func switch_mouse_mode(cursor_visible:bool) -> void:
	if cursor_visible: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func get_camera_center() -> Vector3:
	var screen_center = get_viewport().get_visible_rect().size / 2
	return player_camera.project_ray_origin(screen_center)

func get_target_point() -> Vector3:
	var screen_center = get_viewport().get_visible_rect().size / 2
	var ray_origin = player_camera.project_ray_origin(screen_center)
	var ray_normal = player_camera.project_ray_normal(screen_center)
	var ray_end = ray_origin + (ray_normal * target_max_distance)
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	return result.position if result else ray_end

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#rotate character with the camera
		rotate_y(-event.relative.x * camera_sensitivity)
		#tilt with limits
		camera_pitch -= event.relative.y * camera_sensitivity
		camera_pitch = clamp(camera_pitch, deg_to_rad(min_tilt), deg_to_rad(max_tilt))
		$PlayerCamera.rotation.x = camera_pitch

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): 
		get_tree().quit()
	if event.is_action_pressed("invocation"): 
		invocation_menu.visible = !invocation_menu.visible
	if event.is_action_pressed("conjure"):
		invoker.conjure()

func _physics_process(delta: float) -> void:
	get_target_point()
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	var input_dir := Input.get_vector("rightward", "leftward", "backward", "forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * walking_speed
		velocity.z = direction.z * walking_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walking_speed)
		velocity.z = move_toward(velocity.z, 0, walking_speed)
	move_and_slide()
