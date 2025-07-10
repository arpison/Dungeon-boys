extends Node3D
class_name CharacterModelManager

@export var animation_player: AnimationPlayer
@export var idle_animation: String = "idle"
@export var walk_animation: String = "walk"
@export var run_animation: String = "run"
@export var jump_animation: String = "jump"

var current_animation: String = ""
var is_moving: bool = false
var is_running: bool = false
var is_jumping: bool = false

func _ready():
	if not animation_player:
		animation_player = $AnimationPlayer

func _process(_delta):
	update_animation_state()

func update_animation_state():
	var new_animation = get_appropriate_animation()
	if new_animation != current_animation and animation_player and animation_player.has_animation(new_animation):
		animation_player.play(new_animation)
		current_animation = new_animation

func get_appropriate_animation() -> String:
	if is_jumping:
		return jump_animation
	elif is_moving:
		if is_running:
			return run_animation
		else:
			return walk_animation
	else:
		return idle_animation

func set_movement_state(moving: bool, running: bool = false, jumping: bool = false):
	is_moving = moving
	is_running = running
	is_jumping = jumping 
