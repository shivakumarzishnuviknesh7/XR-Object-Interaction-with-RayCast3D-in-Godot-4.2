extends XROrigin3D

@export var xr_use_interface : String = 'OpenXR'

# Called when the node enters the scene tree for the first time.
func _ready():
	var xr_interface = XRServer.find_interface(xr_use_interface)
	
	if xr_use_interface and xr_interface.is_initialized():
		
		# XR on
		get_viewport().use_xr = true
		

