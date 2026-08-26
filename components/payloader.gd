extends Node
class_name Payloader

@warning_ignore("unused_signal")
signal payload_sent(type: Type, payload: Variant)

var parent_payloader: Payloader
var player_owner: PlayerCharacter
var parent_position: Vector3:
	get: return (get_parent() as Node3D).global_position

enum Type
{ HIT, MELEE_ATTACK, RANGED_ATTACK }

class HitInfo:
	var body: Node3D
	var is_damagable: bool
	var inflicted_damage: float
