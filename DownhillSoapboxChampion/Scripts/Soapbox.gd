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

var soapbox: Node3D
var camera: Node3D
var game_ready: Node3D
var game_over: Node3D

var score_label: RichTextLabel
var final_score_label: RichTextLabel
var health_label: RichTextLabel
var in_air = false

var camera_initial_y
var camera_initial_z
var CAMERA_MAX_Y = 12
var CAMERA_MAX_Z = 12

@export var max_health:int = 5
var health = max_health
var is_game_over = false

var score = 0

func set_children_visibility(node_w_kids: Node3D, visible: bool):
	for kid in node_w_kids.get_children():
		kid.visible=visible

func initialise_labels():
	game_ready = camera.get_node("Game Ready")
	game_over = camera.get_node("Game Over")
	
	score_label = game_ready.get_node("Score")
	final_score_label =game_over.get_node("Final_Score")
	health_label = game_ready.get_node("Health")
	set_score_labels()
	set_health_label()
	
	set_children_visibility(game_over, false)
	set_children_visibility(game_ready, true)
	
	
func _ready():
	soapbox = get_node("Soapbox")
	camera = get_node("Camera3D")
	
	initialise_labels()
	
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
			get_parent().get_node("CharacterBody3D/Audio/LandSound").play()
	elif is_on_floor() and not on_ramp:
		if in_air:
			get_parent().get_node("CharacterBody3D/Audio/LandSound").play()
			in_air = false
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
		
	if not is_game_over:
		velocity.z += SPEED * delta
		velocity.z = min(velocity.z, MAX_SPEED)
	else: 
		velocity.z = 0
	move_and_slide()
	
	var new_camera_position = camera.position
	new_camera_position.y = min(camera_initial_y + velocity.z * 0.25, CAMERA_MAX_Y)
	new_camera_position.z = min(camera_initial_z + velocity.z * 0.25, CAMERA_MAX_Z)
	camera.position = new_camera_position.lerp(new_camera_position, delta)

func _on_area_3d_area_entered(area):
	var obstacle = area.get_parent().name
	match obstacle:
		'Ramp':
			on_ramp = true
			get_parent().get_node("CharacterBody3D/Audio/RampSound").play()
		"Cone", "Haystack":
			colliding = true
			reduce_health(1)
			reduce_score(3)
			get_parent().get_node("CharacterBody3D/Audio/CrashSound").play()
		"Cog":
			increase_health(1)
			get_parent().get_node("CharacterBody3D/Audio/HealthSound").play()
			
func _on_area_3d_area_exited(area):
	var obstacle = area.get_parent().name
	match obstacle:
		'Ramp':
			on_ramp = false
			velocity.z += 2.5
			increase_score(5)
			in_air = true
	

# HEALTH
func reduce_health(damage:int):
	if health - damage >= 0:
		health -= damage
	else:
		health = 0
	set_health_label()
	if health < 1:
		initiate_game_over()

func increase_health(increase:int):
	if health + increase <= max_health:
		health += increase
	else:
		health = max_health
	set_health_label()

func set_health_label():
	health_label.text = "HP: %d/%d" % [health,max_health]
	
func initiate_game_over():
	is_game_over = true
	set_children_visibility(game_over, true)
	set_children_visibility(game_ready, false)

#SCORE
func increase_score(increase: int):
	score += increase
	set_score_labels()

func reduce_score(decrease:int):
		if score - decrease >= 0:
			score -= decrease
		else:
			score = 0
		set_score_labels()
	
func set_score_labels():
	score_label.text = "Score: %d" % score
	final_score_label.text = "Final Score: %d" % score
