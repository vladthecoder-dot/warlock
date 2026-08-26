extends Node

func spawn_sphere(radius: float, position: Vector3) -> Area3D:
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = radius
	collision.shape = sphere
	area.add_child(collision)
	get_tree().root.add_child(area)
	area.global_position = position
	return area
