extends Node3D

var road_empty = load("res://Prefabs/Roads/Empty.tscn")
var road_empty_centre = load("res://Prefabs/Roads/EmptyCentre.tscn")

var roads : Array[Node3D] = []

func _ready():
	for i in range(1000):
		var new_left_road = road_empty.instantiate()
		add_child(new_left_road)
		if i > 0:
			new_left_road.position = roads[i-1].get_node("AttachPoint").global_position
		roads.append(new_left_road)
		for j in range(4):
			var new_road = road_empty.instantiate()
			add_child(new_road)
			new_road.position = new_left_road.position
			new_road.position.x += j+1
