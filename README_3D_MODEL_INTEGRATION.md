# 3D Model Integration Guide

This guide will help you integrate your 3D character model and animations into your Godot project.

## Project Structure

```
assets/
├── models/          # Place your 3D model files here (.gltf, .glb, .fbx, .obj)
├── textures/        # Place texture files here (.png, .jpg, .tga)
└── animations/      # Place animation files here (.tres, .res)

player_character.tscn          # New player character scene with 3D model support
enhanced_proto_controller.gd   # Enhanced controller with animation support
character_model_manager.gd     # Script to manage 3D models and animations
```

## Supported File Formats

### 3D Models
- **GLTF/GLB** (Recommended) - Best compatibility with Godot
- **FBX** - Good support, widely used
- **OBJ** - Basic support, no animations
- **DAE (Collada)** - Good support

### Textures
- **PNG** - Best for transparency
- **JPG** - Good for photos
- **TGA** - Good for high quality
- **WebP** - Good compression

### Animations
- **GLTF/GLB** - Animations embedded in model
- **FBX** - Animations embedded in model
- **Godot Animation Resources** (.tres) - Exported from Godot

## Step-by-Step Integration

### 1. Prepare Your 3D Model

1. **Export your model** in GLTF/GLB format (recommended)
2. **Ensure proper scaling** - 1 unit = 1 meter in Godot
3. **Check the model orientation** - Y should be up in Godot
4. **Include animations** if you have them

### 2. Import Your Model

1. **Copy your model file** to `assets/models/`
2. **Open Godot Editor**
3. **Select your model file** in the FileSystem panel
4. **In the Import tab**, configure:
   - **Scale**: Adjust if needed (usually 1.0)
   - **Root Type**: Node3D
   - **Root Name**: Your model name
   - **Import Animations**: Check if your model has animations
   - **Optimize**: Check for better performance

### 3. Set Up the Player Character

1. **Open `player_character.tscn`** in the editor
2. **Select the PlayerCharacter node**
3. **In the Inspector**, find the script properties
4. **Set up your input actions** if needed

### 4. Load Your 3D Model

#### Option A: Through Code (Recommended)
Add this to your main scene script or call it from the editor:

```gdscript
# Get reference to the player character
var player = $PlayerCharacter

# Load your 3D model
player.load_character_model("res://assets/models/your_character.glb")

# Load animations (if separate files)
player.load_character_animations("res://assets/animations/")
```

#### Option B: Through the Editor
1. **Open `player_character.tscn`**
2. **Select the CharacterModel node**
3. **In the Inspector**, set the `character_model` property to your model
4. **Set the `animation_player`** property if your model has one

### 5. Configure Animations

The system automatically handles these animations:
- **Idle** - When not moving
- **Walk** - When moving at normal speed
- **Run** - When sprinting
- **Jump** - When jumping

#### Animation Naming
Your animations should be named:
- `idle` or `Idle`
- `walk` or `Walk`
- `run` or `Run`
- `jump` or `Jump`

#### Custom Animation Names
You can change the animation names in the CharacterModel node:
1. **Select the CharacterModel node**
2. **In the Inspector**, modify:
   - `idle_animation`
   - `walk_animation`
   - `run_animation`
   - `jump_animation`

## Troubleshooting

### Model Not Appearing
- Check if the model file path is correct
- Ensure the model is properly imported
- Check the model's scale and position
- Verify the model has a visible mesh

### Animations Not Working
- Ensure animations are included in the model file
- Check animation names match the expected names
- Verify the AnimationPlayer is properly set up
- Check if animations are properly imported

### Performance Issues
- Use GLTF/GLB format for best performance
- Optimize your model (reduce polygon count)
- Use compressed textures
- Enable model optimization in import settings

### Collision Issues
- The collision shape is separate from the visual model
- Adjust the `Collider` node's shape if needed
- The collision uses a capsule shape by default

## Advanced Configuration

### Custom Animation States
You can add more animation states by modifying `character_model_manager.gd`:

```gdscript
# Add new animation properties
@export var attack_animation: String = "attack"
@export var crouch_animation: String = "crouch"

# Add new state variables
var is_attacking: bool = false
var is_crouching: bool = false

# Update the animation selection logic
func get_appropriate_animation() -> String:
    if is_attacking:
        return attack_animation
    elif is_crouching:
        return crouch_animation
    # ... rest of the logic
```

### Model Scaling and Positioning
If your model appears too large/small or in the wrong position:

1. **Select the CharacterModel node**
2. **Adjust the Transform properties**:
   - **Scale**: Change the size
   - **Position**: Move the model
   - **Rotation**: Rotate the model

### Multiple Animation Players
If your model has multiple AnimationPlayers:

```gdscript
# In character_model_manager.gd, modify find_animation_player
func find_animation_player(node: Node) -> AnimationPlayer:
    # Look for specific animation player names
    if node is AnimationPlayer:
        if node.name == "MainAnimationPlayer":  # Your specific name
            return node
    
    # Recursively search children
    for child in node.get_children():
        var result = find_animation_player(child)
        if result:
            return result
    
    return null
```

## Next Steps

Once your 3D model is integrated:

1. **Test all animations** work correctly
2. **Adjust collision shape** if needed
3. **Fine-tune movement speeds** for your character
4. **Add sound effects** for footsteps, jumps, etc.
5. **Create additional animations** as needed

## File Organization Tips

- Keep model files organized by character type
- Use descriptive names for your files
- Create subfolders for different character types
- Keep texture files with their corresponding models
- Document any special import settings

Example structure:
```
assets/
├── models/
│   ├── player/
│   │   ├── player_character.glb
│   │   └── player_character_textures/
│   └── enemies/
│       └── enemy_models/
├── textures/
│   ├── player/
│   └── environment/
└── animations/
    ├── player/
    └── enemies/
``` 