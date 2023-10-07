extends Node3D


enum RoadType {
	EMPTY_CENTRE,
	EMPTY
}

var gridmap : GridMap

func _ready():
	gridmap = get_node("GridMap")

func _process(delta):
	for z in range(1000):
		for x in range(5):
			if x == 2:
				gridmap.set_cell_item(Vector3i(x, 0, z), RoadType.EMPTY_CENTRE)
			else:
				gridmap.set_cell_item(Vector3i(x, 0, z), RoadType.EMPTY)
