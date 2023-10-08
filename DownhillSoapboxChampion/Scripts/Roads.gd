extends Node3D


enum RoadType {
	EMPTY_CENTRE,
	EMPTY,
	END_R,
	END_L
}

@export var obstacles: Array[PackedScene]
var ramp_scene = load("res://Prefabs/Ramp.tscn")
var pickup_scene = load("res://Prefabs/Cog.tscn")

var gridmap : GridMap
var current_obstacles = []

var rng = RandomNumberGenerator.new()

var can_reset = false

func _ready():
	gridmap = get_node("GridMap")
	reset_level()

func _process(delta):
	if can_reset and Input.is_action_just_pressed("Space"):
		reset_level()

func reset_level():
	can_reset = false
	
	for obstacle in current_obstacles:
		obstacle.queue_free()
	current_obstacles = []
	
	for z in range(1000):
		for x in range(5):
			match x:
				0: 
					gridmap.set_cell_item(Vector3i(x, 0, z), RoadType.END_L)
				2:
					gridmap.set_cell_item(Vector3i(x, 0, z), RoadType.EMPTY_CENTRE)
				4:
					gridmap.set_cell_item(Vector3i(x, 0, z), RoadType.END_R)
				_: 
					gridmap.set_cell_item(Vector3i(x, 0, z), RoadType.EMPTY)
				
			if z > 5:
				var obstacle_chance = rng.randi_range(1, 5)
				var ramp_chance = rng.randi_range(1, 30)
				var pickup_chance = rng.randi_range(1, 20)
				if x == 1 or x == 2 or x == 3:
					# place random obstacle 10% of the time 
					if obstacle_chance == 1:
						place_obstacle(obstacles[randi_range(0, obstacles.size()-1)], x, z)
					elif ramp_chance == 1:
						place_ramp(x, z)
					elif pickup_chance == 1:
						place_pickup(x, z)
				else:
					if obstacle_chance == 1:
						place_obstacle(obstacles[0], x, z)

func place_obstacle(scene, x, z):
	var new_scene = scene.instantiate() 
	var new_position = gridmap.map_to_local(Vector3(x, 0, z))
	new_position.x += rng.randf_range(-1, 1)
	new_position.z += rng.randf_range(-1, 1)
	new_scene.position = new_position
	new_scene.rotation.y = rng.randf_range(0, 2*PI)
	add_child(new_scene)
	current_obstacles.append(new_scene)
	
func place_ramp(x, z):
	var new_ramp = ramp_scene.instantiate()
	var new_position = gridmap.map_to_local(Vector3(x, 0, z))
	new_position.x += rng.randf_range(-1, 1)
	new_position.z += rng.randf_range(-1, 1)
	new_ramp.position = new_position
	add_child(new_ramp)
	current_obstacles.append(new_ramp)

func place_pickup(x, z):
	var new_ramp = pickup_scene.instantiate()
	var new_position = gridmap.map_to_local(Vector3(x, 0, z))
	new_position.x += rng.randf_range(-1, 1)
	new_position.z += rng.randf_range(-1, 1)
	new_ramp.position = new_position
	add_child(new_ramp)
	current_obstacles.append(new_ramp)


func _on_soapbox_game_over_signal():
	can_reset = true
