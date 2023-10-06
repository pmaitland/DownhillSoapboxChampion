extends RigidBody3D

var speed = 1.5

var default_rotation = 180 * PI/180
var turn_amount = 40 * PI/180

var default_position = 0
var shift_amount = 0.1

func _physics_process(delta):
	rotation.x = 0
	rotation.y = 0
	rotation.z = 0
	
	if Input.is_action_pressed("Left"):
		position.x -= speed * delta
		get_node("Soapbox-0").rotation.y = default_rotation - turn_amount
		get_node("Soapbox-0").position.x = default_position - shift_amount
	elif Input.is_action_pressed("Right"):
		position.x += speed * delta
		get_node("Soapbox-0").rotation.y = default_rotation + turn_amount
		get_node("Soapbox-0").position.x = default_position + shift_amount
	elif Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
		get_node("Soapbox-0").rotation.y = default_rotation
		get_node("Soapbox-0").position.x = default_position
