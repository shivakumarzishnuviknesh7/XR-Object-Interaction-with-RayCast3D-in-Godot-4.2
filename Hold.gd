extends RayCast3D

@export var highlight_mat : BaseMaterial3D
@export var holder_node : Node3D
@export var pickable_group : String
@export var xr_action : String = 'trigger_click'
@export var key: String = "ui_accept"  # Key action to initiate grabbing
@export var min_scale: Vector3 = Vector3(0.2, 0.2, 0.2)  # Minimum scale for the object when it's farthest
@export var max_scale: Vector3 = Vector3(2, 2, 2)  # Maximum scale for the object when it's nearest
@export var max_distance: float = 10.0  # Distance at which the object reaches its minimum scale
@export var min_distance: float = 1.0  # Distance at which the object reaches its maximum scale
@export var floor_y: float = 0.0  # Y position of the floor
@export var max_horizontal_distance: float = 5.0  # Maximum horizontal distance from the hold point

var obj: Node3D = null  # Variable to hold the object currently grabbed
var original_scale: Vector3 = Vector3.ONE  # Variable to store the original scale of the object

enum InteractioMode { INTERACT_CLUTCHING, INTERACT_TRIGGER }
@export var interaction_mode : InteractioMode = InteractioMode.INTERACT_TRIGGER 

var highlight_meshes = []
var colliders = []

func _ready():
	holder_node = get_node("../Hold")  # Assuming 'Hold' is a sibling node where you want to hold the grabbed object

func _physics_process(delta):
	# Remove override for highlights
	for e in highlight_meshes:
		e.material_override = null

	# Empty selected mesh
	highlight_meshes = []
	colliders = []

	if self.is_colliding():
		var c = self.get_collider()

		# If pickable or not (NPC)
		if pickable_group in c.get_groups():
			colliders.append(c)

		# Get children
		for element in c.get_children():
			# Check if this is a Mesh and if highlight_mat is set
			if element is MeshInstance3D and highlight_mat:
				# Override and store
				element.material_override = highlight_mat
				highlight_meshes.append(element)

		match interaction_mode:
			# Using trigger for clutch and release
			InteractioMode.INTERACT_CLUTCHING:
				if Input.is_action_just_pressed(key):
					if holder_node.get_child_count():
						for child in holder_node.get_children():
							child.reparent(get_node('/root'))
					else:
						c.reparent(holder_node)

			InteractioMode.INTERACT_TRIGGER:
				# Need to hold key/trigger to interact
				if Input.is_action_pressed(key):
					_on_controller_right_button_pressed(xr_action)

				elif Input.is_action_just_released(key):
					_on_controller_right_button_released(xr_action)

			_:
				print('Unknown Mode!')

func grab_object():
	var collider = get_collider()
	if collider != null and collider.is_in_group(pickable_group):
		obj = collider  # Assign the collider to obj if it belongs to the "grab" group
		original_scale = obj.scale  # Store the original scale of the object

func hold_object():
	var new_position = holder_node.global_transform.origin

	# Calculate horizontal distance and restrict it
	var horizontal_distance = Vector2(obj.global_transform.origin.x, obj.global_transform.origin.z).distance_to(Vector2(holder_node.global_transform.origin.x, holder_node.global_transform.origin.z))
	if horizontal_distance > max_horizontal_distance:
		var direction = (obj.global_transform.origin - holder_node.global_transform.origin).normalized()
		new_position += direction * max_horizontal_distance

	# Ensure the object stays near the floor
	new_position.y = floor_y

	obj.global_transform.origin = new_position

	if obj is RigidBody3D:
		obj.linear_velocity = Vector3.ZERO  # Stop rigid body movement while holding

	# Adjust the scale based on the distance
	var distance = obj.global_transform.origin.distance_to(holder_node.global_transform.origin)
	var t = clamp((distance - min_distance) / (max_distance - min_distance), 0, 1)
	obj.scale = original_scale.lerp(min_scale, t).lerp(min_scale, 1 - t)

func release_object():
	if obj != null:
		obj.scale = original_scale  # Restore the original scale of the object
		if obj is RigidBody3D:
			obj.linear_velocity = Vector3.ZERO  # Ensure the object stops moving when released
		obj = null  # Clear obj after releasing the object

func _on_controller_right_button_pressed(name):
	if holder_node.get_child_count() == 0 and not colliders.is_empty():
		for c in colliders:
			c.reparent(holder_node)

func _on_controller_right_button_released(name):
	for child in holder_node.get_children():
		child.reparent(get_node('/root'))
