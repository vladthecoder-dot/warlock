extends Node
class_name Inventory

signal updated
@export var items : Array[Item]
@export var max_slots := 16

func _ready() -> void:
	if items.size() > max_slots: items.resize(max_slots)
	updated.emit()

func is_index_valid(index:int) -> bool:
	return index >= 0 and index < items.size()

func add_item(item:Item) -> bool:
	if items.size() == max_slots: return false
	items.append(item)
	updated.emit()
	return true

func remove_item(item_index:int) -> Item:
	if not is_index_valid(item_index): return null
	var item := items[item_index]
	items.remove_at(item_index)
	updated.emit()
	return item

func clear() -> void:
	items.clear()
	updated.emit()
