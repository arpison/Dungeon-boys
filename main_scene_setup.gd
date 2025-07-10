extends Node3D

## Example script showing how to set up a 3D model in your main scene
## Attach this script to your main scene or create a separate setup script

@export var character_model_path: String = "res://assets/models/your_character.glb"
@export var animations_path: String = "res://assets/animations/"

func _ready():
	setup_character_model()

func setup_character_model():
	# Get reference to the player character
	var player = $PlayerCharacter
	
	if not player:
		push_error("PlayerCharacter not found in scene!")
		return
	
	# Load the 3D model
	if FileAccess.file_exists(character_model_path):
		player.load_character_model(character_model_path)
		print("Character model loaded successfully: ", character_model_path)
	else:
		push_warning("Character model not found: ", character_model_path)
		print("Please place your 3D model in: ", character_model_path)
	
	# Load animations (if separate files)
	if DirAccess.dir_exists_absolute(animations_path):
		player.load_character_animations(animations_path)
		print("Animations loaded from: ", animations_path)
	else:
		print("Animations directory not found: ", animations_path)
		print("Animations will be loaded from the model file if available")

## Alternative: Load model through editor
## 1. Open player_character.tscn
## 2. Select the CharacterModel node
## 3. In the Inspector, set the character_model property to your model file
## 4. Set the animation_player property if your model has one

## Example of loading different models based on conditions
func load_character_by_type(character_type: String):
	var player = $PlayerCharacter
	
	match character_type:
		"warrior":
			player.load_character_model("res://assets/models/warrior.glb")
		"mage":
			player.load_character_model("res://assets/models/mage.glb")
		"archer":
			player.load_character_model("res://assets/models/archer.glb")
		_:
			player.load_character_model("res://assets/models/default_character.glb")

## Example of loading model with custom settings
func load_character_with_settings():
	var player = $PlayerCharacter
	
	# Load the model
	player.load_character_model(character_model_path)
	
	# Customize the character model manager
	var model_manager = player.get_node("CharacterModel")
	if model_manager:
		# Set custom animation names
		model_manager.idle_animation = "Idle"
		model_manager.walk_animation = "Walk"
		model_manager.run_animation = "Run"
		model_manager.jump_animation = "Jump"
		
		# Adjust model scale if needed
		model_manager.scale = Vector3(1.0, 1.0, 1.0)
		
		print("Character model loaded with custom settings") 