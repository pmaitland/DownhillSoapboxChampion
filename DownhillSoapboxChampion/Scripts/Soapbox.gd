extends RigidBody3D

var speed = 1.5

var default_y_rotation
var y_turn_amount = 40 * PI/180

var default_position = 0
var shift_amount = 0.1

var soapbox

func _ready():
	soapbox = get_node("Soapbox")
	default_y_rotation = soapbox.rotation.y

func _physics_process(delta):
	rotation.x = 0
	rotation.y = 0
	rotation.z = 0
	
	if Input.is_action_pressed("Left") && Input.is_action_pressed("Right"):
		soapbox.rotation.y = default_y_rotation
		soapbox.position.x = default_position
	elif Input.is_action_pressed("Left"):
		position.x -= speed * delta
		soapbox.rotation.y = default_y_rotation - y_turn_amount
		soapbox.position.x = default_position - shift_amount
	elif Input.is_action_pressed("Right"):
		position.x += speed * delta
		soapbox.rotation.y = default_y_rotation + y_turn_amount
		soapbox.position.x = default_position + shift_amount
	else:
		soapbox.rotation.y = default_y_rotation
		soapbox.position.x = default_position
