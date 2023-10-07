extends CharacterBody3D

var gravity: int = 5

var SPEED = 5

var default_y_rotation
var y_turn_amount = 40 * PI/180

var soapbox

func _ready():
	soapbox = get_node("Soapbox")
	default_y_rotation = soapbox.rotation.y

func _physics_process(delta):
	if Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
		soapbox.rotation.y = default_y_rotation
	elif Input.is_action_pressed("Left"):
		soapbox.rotation.y = default_y_rotation - y_turn_amount
	elif Input.is_action_pressed("Right"):
		soapbox.rotation.y = default_y_rotation + y_turn_amount
	else:
		soapbox.rotation.y = default_y_rotation
	
	velocity.y -= gravity * delta

	var input_dir = Input.get_vector("Left", "Right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
