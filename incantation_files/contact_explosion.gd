extends Node
class_name ContactExplosion

var payloader: Payloader
var radius: float = 5
var damage_time: float = 0.1

func _ready() -> void:
	payloader = get_parent() as Payloader
	payloader.payload_sent.connect(func(type: Payloader.Type, _payload):
		if type == Payloader.Type.HIT: explode())

func explode() -> void:
	var area = AreaSpawner.spawn_sphere(radius, payloader.parent_position)
	area.body_entered.connect(func(body: Node3D):
		print("explosion hit"))
	get_tree().create_timer(damage_time).timeout.connect(area.queue_free)
