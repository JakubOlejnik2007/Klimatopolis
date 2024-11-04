extends Node3D

var navigation_speed = 0.5
var viewport_minimum = 200
var viewport_resolution_variance = 800
var viewport_resolution = Vector2(1200, 800)

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_update_viewport_resolution()
	get_tree().get_root().set_size(viewport_resolution)


func _update_viewport_resolution():
	var fov_factor = $CameraPivot/SkyCamera.fov / 100.0
	viewport_resolution = Vector2(fov_factor * viewport_resolution_variance + 400, fov_factor * viewport_resolution_variance)
	get_tree().get_root().set_size(viewport_resolution)
	print("Viewport Resolution: ", viewport_resolution)

func _process(_delta):
	var forward = -$CameraPivot.transform.basis.z.normalized() * navigation_speed

	if Input.is_key_pressed(KEY_W):
		$CameraPivot.translate(forward)
	if Input.is_key_pressed(KEY_S):
		$CameraPivot.translate(-forward)

	if Input.is_key_pressed(KEY_A):
		$CameraPivot.translate(forward.cross(Vector3.UP).normalized() * navigation_speed / 1.5 * -1)
	if Input.is_key_pressed(KEY_D):
		$CameraPivot.translate(-forward.cross(Vector3.UP).normalized() * navigation_speed / 1.5 * -1)

	if Input.is_action_pressed("ui_left"):
		$CameraPivot.rotate_y(1)
	if Input.is_action_pressed("ui_right"):
		$CameraPivot.rotate_y(-1)

func _input(event):
	if Input.is_action_just_pressed("zoom_in"):
		_adjust_camera_size(-1)

	if Input.is_action_just_pressed("zoom_out"):
		_adjust_camera_size(1)

func _adjust_camera_size(delta):
	var new_size = clamp($CameraPivot/SkyCamera.size + delta, 5, 100)
	if new_size != $CameraPivot/SkyCamera.size:
		$CameraPivot/SkyCamera.size = new_size
		navigation_speed = new_size / 100.0
		print("Navigation Speed: ", navigation_speed)
