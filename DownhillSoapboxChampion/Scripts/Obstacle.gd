extends Node3D

@export var intact_obstacle: Node3D
@export var destroyed_obstacle: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	intact_obstacle.visible=true
	destroyed_obstacle.visible=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	print("Obstacle KO'd")
	intact_obstacle.visible = false
	destroyed_obstacle.visible = true
	set_process(false)
