extends Area3D


var characterBody

func _ready():
	characterBody = get_parent()

func _on_area_entered(area):
	characterBody.collide_with_obstacle()
