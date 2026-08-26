extends Area3D
class_name ProjectileShot

@export var speed: float = 15
@export var damage: float = 10
@onready var payloader: Payloader = $Payloader

var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	global_position = payloader.player_owner.invocation_holder.global_position
	var target_position = payloader.player_owner.get_target_point()
	direction = (target_position - global_position).normalized()
	look_at(target_position, Vector3.UP)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func on_body_entered(body: Node3D) -> void:
	print("kaboom")
	var hit_info := Payloader.HitInfo.new()
	hit_info.body = body
	hit_info.inflicted_damage = damage
	direction = Vector3.ZERO
	visible = false
	set_deferred("monitoring", false)
	payloader.payload_sent.emit(Payloader.Type.HIT, body)
