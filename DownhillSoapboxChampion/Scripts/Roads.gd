extends Node3D

var road_empty = load("res://Prefabs/Roads/Empty.tscn")

var roads : Array[Node3D] = []

func _ready():
	for i in range(1000):
		var new_road = road_empty.instantiate()
		add_child(new_road)
		if i > 0:
			new_road.position = roads[i-1].get_node("AttachPoint").global_position
		roads.append(new_road)
