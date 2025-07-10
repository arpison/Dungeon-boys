# Enhanced ProtoController Guide

## 🎮 **Dual Camera System**

The enhanced controller now supports **both first-person and third-person** camera modes with all the original ProtoController functionality!

## 📋 **Features**

### **Camera Modes:**
- **First-Person**: Camera inside character's head (original ProtoController)
- **Third-Person**: Camera behind character with smooth following

### **Movement System:**
- **First-Person**: Move in the direction you're looking
- **Third-Person**: Move in the direction the camera is facing
- **Character Rotation**: Automatically faces movement direction in third-person

### **All Original Features:**
- ✅ Walking, running, jumping
- ✅ Mouse look controls
- ✅ Freefly mode (noclip)
- ✅ Gravity and collision
- ✅ Sprint functionality
- ✅ Input action mapping

## 🎯 **Controls**

### **Movement:**
- **WASD**: Move in camera direction
- **Space**: Jump
- **Shift**: Sprint (if enabled)

### **Camera:**
- **Mouse**: Rotate camera
- **Mouse Wheel**: Zoom in/out (third-person only)
- **Toggle Camera**: Switch between first-person and third-person

### **Other:**
- **Left Click**: Capture mouse
- **Escape**: Release mouse
- **Freefly Key**: Toggle noclip mode (if enabled)

## ⚙️ **Configuration**

### **Camera Settings (Inspector):**
- `camera_mode`: "first_person" or "third_person"
- `can_toggle_camera`: Enable/disable camera switching
- `camera_distance`: Distance from player (third-person)
- `camera_height`: Height above player (third-person)
- `min_camera_distance`: Closest zoom (third-person)
- `max_camera_distance`: Farthest zoom (third-person)
- `camera_smoothness`: How smoothly camera follows (third-person)

### **Movement Settings:**
- `base_speed`: Normal movement speed
- `sprint_speed`: Speed when sprinting
- `jump_velocity`: Jump height
- `look_speed`: Mouse sensitivity

## 🔧 **Setup Instructions**

### **1. Input Actions**
You may need to add these input actions in Project Settings:
- `toggle_camera`: Key to switch camera modes (e.g., 'C' or 'V')

### **2. Camera Mode**
Set the initial camera mode in the Inspector:
- `camera_mode = "first_person"` for first-person view
- `camera_mode = "third_person"` for third-person view

### **3. 3D Model Integration**
Your 3D model is already integrated! The system will:
- Automatically handle animations (idle, walk, run, jump)
- Work with both camera modes
- Maintain proper collision detection

## 🎮 **Usage Examples**

### **Switch to First-Person:**
```gdscript
# In code
player.set_camera_mode("first_person")

# Or in Inspector
camera_mode = "first_person"
```

### **Switch to Third-Person:**
```gdscript
# In code
player.set_camera_mode("third_person")

# Or in Inspector
camera_mode = "third_person"
```

### **Toggle Camera Mode:**
```gdscript
# In code
player.toggle_camera_mode()

# Or press the toggle_camera input action
```

## 🔄 **Migration from Original ProtoController**

The enhanced controller is **100% compatible** with the original ProtoController:
- All original properties and methods work
- Same input system
- Same movement mechanics
- Just adds camera mode functionality

## 🎯 **Best Practices**

### **For First-Person Games:**
- Set `camera_mode = "first_person"`
- Disable `can_toggle_camera` if you want to lock it
- Use original ProtoController movement

### **For Third-Person Games:**
- Set `camera_mode = "third_person"`
- Adjust `camera_distance` and `camera_height` for your character
- Enable `can_toggle_camera` for player choice

### **For Hybrid Games:**
- Enable `can_toggle_camera`
- Let players choose their preferred view
- Both modes work seamlessly together

## 🐛 **Troubleshooting**

### **Camera Not Switching:**
- Check if `can_toggle_camera` is enabled
- Verify the `toggle_camera` input action is set up
- Ensure both cameras exist in the scene

### **Movement Issues:**
- First-person: Movement follows character direction
- Third-person: Movement follows camera direction
- Character automatically rotates in third-person

### **3D Model Not Visible:**
- In first-person: Model is hidden (as expected)
- In third-person: Model should be visible
- Check model positioning and scale

## 🎉 **Ready to Use!**

Your enhanced controller is now ready with:
- ✅ Dual camera system
- ✅ All original ProtoController features
- ✅ 3D model integration
- ✅ Animation support
- ✅ Smooth camera transitions

Enjoy your enhanced gaming experience! 