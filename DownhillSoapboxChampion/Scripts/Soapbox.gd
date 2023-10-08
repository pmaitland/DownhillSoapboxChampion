extends CharacterBody3D

var gravity: int = 9

var SPEED = 1
var MAX_SPEED = 20

var default_y_rotation
var y_turn_amount = 40 * PI/180
var y_spin_amount = 15 * PI/180

var colliding = false
var colliding_duration = 0
var colliding_limit = 10

var on_ramp = false;
var on_ramp_rotation = 30 * PI/180

var soapbox
var camera
var camera_initial_y
var camera_initial_z
var CAMERA_MAX_Y = 12
var CAMERA_MAX_Z = 12

func _ready():
	soapbox = get_node("Soapbox")
	camera = get_node("Camera3D")
	camera_initial_y = camera.position.y
	camera_initial_z = camera.position.z
	default_y_rotation = soapbox.rotation.y

func _physics_process(delta):
	if on_ramp:
		soapbox.rotation.x = on_ramp_rotation
	else:
		soapbox.rotation.x = 0
		
	velocity.x = 0
		
	if colliding:
		soapbox.rotation.y += y_spin_amount
		colliding_duration += 1
		if colliding_duration <= colliding_limit:
			velocity.z *= 0.9
			velocity.y += velocity.z * 0.1
		elif is_on_floor():
			colliding = false
			colliding_duration = 0
			soapbox.rotation.y = default_y_rotation
	elif is_on_floor() and not on_ramp:
		if Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
			soapbox.rotation.y = default_y_rotation
		elif Input.is_action_pressed("Left"):
			soapbox.rotation.y = default_y_rotation - y_turn_amount
		elif Input.is_action_pressed("Right"):
			soapbox.rotation.y = default_y_rotation + y_turn_amount
		else:
			soapbox.rotation.y = default_y_rotation
			
		var input_dir = Input.get_vector("Left", "Right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * velocity.z
		else:
			velocity.x = move_toward(velocity.x, 0, velocity.z)
		
	velocity.y -= gravity * delta
		
	velocity.z += SPEED * delta
	velocity.z = min(velocity.z, MAX_SPEED)
		
	move_and_slide()
	
	var new_camera_position = camera.position
	new_camera_position.y = min(camera_initial_y + velocity.z * 0.25, CAMERA_MAX_Y)
	new_camera_position.z = min(camera_initial_z + velocity.z * 0.25, CAMERA_MAX_Z)
	camera.position = new_camera_position.lerp(new_camera_position, delta)

func _on_area_3d_area_entered(area):
	if area.get_parent().name == 'Ramp':
		on_ramp = true
	else:
		colliding = true

func _on_area_3d_area_exited(area):
	if area.get_parent().name == 'Ramp':
		on_ramp = false
		velocity.z += 2.5
