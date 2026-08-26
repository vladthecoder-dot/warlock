extends Resource
class_name Incantation

@export var name: String = "PLACEHOLDER"
@export var image: Texture2D
@export var type: Type
@export var payload: Variant
@export_range(0, 99, 1, "or_greater") var cost: int

enum Type 
{ NONE, PROJECTILE, MODIFIER, TRIGGER, MULTISHOT }
