
# XR Object Interaction with RayCast3D in Godot 4.2

## Overview

This project demonstrates how to use a RayCast3D node to interact with objects in a 3D environment using an XR controller. The script allows the user to grab, hold, and release objects, with the objects scaling based on their distance to a holding point.

## Features

- **Raycasting**: Detects objects within the path of a ray cast from the XR controller.
- **Object Highlighting**: Highlights objects that can be interacted with.
- **Grabbing and Holding Objects**: Allows the user to grab and hold objects using the XR controller.
- **Dynamic Scaling**: Adjusts the scale of the held object based on its distance from the holding point.
- **Clutch and Trigger Modes**: Supports different interaction modes for grabbing objects.

## Installation

1. **Clone the Repository**:
    ```sh
    git clone <repository_url>
    ```
2. **Open in Godot**:
    - Open the Godot Engine.
    - Import the project by selecting the project.godot file.

## Scene Setup

1. **Hierarchy**:
    Ensure the scene hierarchy is similar to the following structure:
    ```plaintext
    Node3D
    ├── XROrigin3D
    │   ├── DirectionalLight3D
    │   ├── RigidBody3D
    │   └── Player (with RayCast3D script)
    │       ├── CSGMesh
    │       ├── CollisionShape3D
    │       ├── Hold (empty Node3D for holding objects)
    │       └── RayCast3D (script attached)
    ├── WorldEnvironment
    ├── CSGBox3D
    └── wall1, wall2, wall3, wall4 (example walls)
    ```

2. **Script Attachment**:
    - Attach the provided script to the RayCast3D node under the Player node.

## Configuration

The script has several export variables that can be configured in the Godot Editor:

- `highlight_mat` (BaseMaterial3D): Material used to highlight objects that can be grabbed.
- `holder_node` (Node3D): The node where the grabbed object will be held.
- `pickable_group` (String): The group name used to identify objects that can be grabbed.
- `xr_action` (String): The action name for the XR controller button used to grab objects.
- `key` (String): The key action to initiate grabbing (e.g., "ui_accept").
- `min_scale` (Vector3): The minimum scale for the object when it's farthest.
- `max_scale` (Vector3): The maximum scale for the object when it's nearest.
- `max_distance` (float): The distance at which the object reaches its minimum scale.
- `min_distance` (float): The distance at which the object reaches its maximum scale.
- `floor_y` (float): The Y position of the floor.
- `max_horizontal_distance` (float): The maximum horizontal distance from the hold point.
- `interaction_mode` (InteractioMode): The mode of interaction (clutch or trigger).

## Usage

1. **Run the Scene**: Start the scene in Godot.
2. **Grab Objects**:
    - Point the XR controller at an object within the `pickable_group`.
    - Press the `xr_action` button (or key) to grab the object.
3. **Hold Objects**:
    - While holding the grab button, the object will follow the hold point.
    - The object’s scale will adjust based on its distance from the hold point.
4. **Release Objects**:
    - Release the `xr_action` button (or key) to release the object.

## Interaction Modes

- **Clutching Mode** (`INTERACT_CLUTCHING`): Grab and hold the object while the button is pressed. Release when the button is released.
- **Trigger Mode** (`INTERACT_TRIGGER`): Grab the object on button press and hold it until the button is released.

## Notes

- Ensure that objects intended to be picked up are in the `pickable_group`.
- The `holder_node` should be positioned appropriately to hold the grabbed objects.

## Troubleshooting

- **Object Not Highlighting**: Check if the object is in the correct group and if `highlight_mat` is assigned.
- **Object Not Grabbing**: Ensure the `xr_action` or `key` is correctly set and that the RayCast3D is properly configured.
- **Object Scaling Issues**: Verify the values for `min_scale`, `max_scale`, `min_distance`, and `max_distance`.

