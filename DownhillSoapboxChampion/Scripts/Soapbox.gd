extends RigidBody3D


func _physics_process(delta):
	if Input.is_action_pressed("Left"):
		position.x -= 0.6 * delta
		get_node("Soapbox-0").rotation.y = 140 * PI/180
	elif Input.is_action_pressed("Right"):
		position.x += 0.6 * delta
		get_node("Soapbox-0").rotation.y = 220 * PI/180
	else:
		get_node("Soapbox-0").rotation.y = 180 * PI/180
