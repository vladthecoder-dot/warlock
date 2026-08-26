extends Node
class_name Invoker

@export var available_incantations: Array[Incantation]
@onready var player_character: PlayerCharacter = $".."
@onready var invocation_holder: Marker3D = $"../PlayerCamera/InvocationHolder"
var saved_invocations: Dictionary
var active_invocaton: String:
	set(value):
		active_invocaton = value
		active_updated.emit()

signal invocations_updated
signal active_updated

func _ready() -> void:
	pass
	#saved_invocations["test"] = [[available_incantations[1], available_incantations[0],
	#available_incantations[0]], [available_incantations[1], available_incantations[0]]] as Array[Array]
	#invocations_updated.emit()

func save_invocation(invocation_name:String, invocation:Array[Incantation]) -> void:
	saved_invocations[invocation_name] = invocation
	invocations_updated.emit()

func conjure() -> void:
	if not saved_invocations.has(active_invocaton): return
	var invocation := saved_invocations[active_invocaton] as Array[Incantation]
	var mod_collection: Array[Incantation]
	var projectile
	var projectile_count = 1
	for inc in invocation:
		match inc.type:
			Incantation.Type.PROJECTILE: pass
			Incantation.Type.TRIGGER: pass
			Incantation.Type.MODIFIER: pass
			Incantation.Type.MULTISHOT: pass
