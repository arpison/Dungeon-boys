# Enhanced ProtoController v1.1
# Based on ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person and third-person games.
# Happy prototyping!

extends CharacterBody3D

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Camera Mode")
## Camera mode: Third Person Only
@export var camera_mode : String = "third_person" # Always third-person
## Can we toggle between camera modes?
@export var can_toggle_camera : bool = false

@export_group("Third Person Camera Settings")
## Distance from player to camera (third-person only)
@export var camera_distance : float = 5.0
## Height offset of camera from player (third-person only)
@export var camera_height : float = 2.0
## Minimum camera distance (third-person only)
@export var min_camera_distance : float = 2.0
## Maximum camera distance (third-person only)
@export var max_camera_distance : float = 10.0
## Camera follow smoothness (third-person only)
@export var camera_smoothness : float = 5.0
## Vertical rotation limits for third-person camera
@export var third_person_vertical_limit : float = 30.0

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "move_left"
## Name of Input Action to move Right.
@export var input_right : String = "move_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "move_up"
## Name of Input Action to move Backward.
@export var input_back : String = "move_down"
## Name of Input Action to Jump.
@export var input_jump : String = "jump"
## Name of Input Action to Sprint.
@export var input_sprint : String = "sprint"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"
## Name of Input Action to toggle camera mode.
@export var input_toggle_camera : String = "toggle_camera"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false
var target_camera_distance : float = 5.0

## IMPORTANT REFERENCES
@onready var collider: CollisionShape3D = $Collider
@onready var camera_pivot: Node3D = $CameraPivot
@onready var third_person_camera: Camera3D = $CameraPivot/ThirdPersonCamera
@onready var character_model_manager: CharacterModelManager = $CharacterModel

func _ready() -> void:
	print("Enhanced ProtoController Ready")
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = 0.0  # Start with level camera
	target_camera_distance = camera_distance
	
	# Set initial camera mode
	set_camera_mode(camera_mode)
	print("Camera mode set to: ", camera_mode)

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	
	# Camera zoom with mouse wheel (third-person only)
	if camera_mode == "third_person" and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_camera_distance = max(min_camera_distance, target_camera_distance - 1.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_camera_distance = min(max_camera_distance, target_camera_distance + 1.0)
	
	# Camera toggle disabled - always third-person
	
	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	# Debug input
	if Input.is_action_just_pressed("move_up"):
		print("move_up pressed in physics process")
	
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (third_person_camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		update_character_animations(false, false, false)
		return
	
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply jumping
	var is_jumping = false
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity
			is_jumping = true

	# Modify speed based on sprinting
	var is_running = false
	if can_sprint and Input.is_action_pressed(input_sprint):
		move_speed = sprint_speed
		is_running = true
	else:
		move_speed = base_speed

	# Apply desired movement to velocity
	var is_moving = false
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		
		# Third-person movement: use camera direction
		var camera_basis = third_person_camera.global_basis
		var move_dir := (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		move_dir.y = 0  # Keep movement on the ground plane
		
		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
			is_moving = true
			
			# Rotate character to face movement direction
			var target_rotation = atan2(move_dir.x, move_dir.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10.0)
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0
	
	# Use velocity to actually move
	move_and_slide()
	
	# Update third-person camera position
	update_third_person_camera(delta)
	
	# Update character animations
	update_character_animations(is_moving, is_running, is_jumping)

func update_third_person_camera(delta: float) -> void:
	if not camera_pivot or not third_person_camera:
		return
	
	# Set camera pivot position (follows player)
	camera_pivot.global_position = global_position + Vector3(0, camera_height, 0)
	
	# Set camera rotation
	camera_pivot.rotation.x = look_rotation.x
	camera_pivot.rotation.y = look_rotation.y
	
	# Set camera distance
	var target_pos = camera_pivot.global_position - camera_pivot.global_basis.z * target_camera_distance
	
	# Smooth camera movement
	if delta > 0:
		third_person_camera.global_position = third_person_camera.global_position.lerp(target_pos, delta * camera_smoothness)
	else:
		third_person_camera.global_position = target_pos

## Rotate us to look around.
## Third-person camera rotation only.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-third_person_vertical_limit), deg_to_rad(third_person_vertical_limit))
	look_rotation.y -= rot_input.x * look_speed

func set_camera_mode(mode: String):
	camera_mode = mode
	# Always use third-person camera
	if third_person_camera:
		third_person_camera.current = true
		update_third_person_camera(0.0)

func update_character_animations(is_moving: bool, is_running: bool, is_jumping: bool):
	if character_model_manager:
		character_model_manager.set_movement_state(is_moving, is_running, is_jumping)

func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false
	if can_toggle_camera and not InputMap.has_action(input_toggle_camera):
		push_warning("Camera toggle disabled. No InputAction found for input_toggle_camera: " + input_toggle_camera)
		can_toggle_camera = false

## Load a 3D model for the character
func load_character_model(model_path: String):
	if character_model_manager:
		character_model_manager.load_character_model(model_path)

## Load animations for the character
func load_character_animations(animations_path: String):
	if character_model_manager:
		character_model_manager.load_animations(animations_path) 
