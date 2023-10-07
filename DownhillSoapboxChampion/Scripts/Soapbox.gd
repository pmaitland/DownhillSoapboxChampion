extends CharacterBody3D

var gravity: int = 9

var SPEED = 1
var MAX_SPEED = 20

var default_y_rotation
var y_turn_amount = 40 * PI/180
var y_spin_amount = 15 * PI/180

var soapbox

var colliding = false
var colliding_duration = 0
var colliding_limit = 10

func _ready():
	soapbox = get_node("Soapbox")
	default_y_rotation = soapbox.rotation.y

func _physics_process(delta):
	if colliding:
		soapbox.rotation.y += y_spin_amount
		colliding_duration += 1
		if colliding_duration <= colliding_limit:
			velocity.y += velocity.z * 0.1
		elif is_on_floor():
			colliding = false
			colliding_duration = 0
			soapbox.rotation.y = default_y_rotation
	else:
		if Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
			soapbox.rotation.y = default_y_rotation
		elif Input.is_action_pressed("Left"):
			soapbox.rotation.y = default_y_rotation - y_turn_amount
		elif Input.is_action_pressed("Right"):
			soapbox.rotation.y = default_y_rotation + y_turn_amount
		else:
			soapbox.rotation.y = default_y_rotation
		
	velocity.y -= gravity * delta

	if is_on_floor():
		var input_dir = Input.get_vector("Left", "Right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * velocity.z
		else:
			velocity.x = move_toward(velocity.x, 0, velocity.z)
	else:
		velocity.x = 0
		
	velocity.z += SPEED * delta
	velocity.z = min(velocity.z, MAX_SPEED)
		
	move_and_slide()
	
func collide_with_obstacle():
	colliding = true
	velocity.z *= 0.5
