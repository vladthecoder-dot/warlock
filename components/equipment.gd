extends Node
class_name Equipment

@export var inventory : Inventory
var equipment : Dictionary

func equip_item(item_index:int, equipment_slot:String) -> void:
	if not inventory.is_index_valid(item_index): return
	equipment[equipment_slot] = inventory.remove_item(item_index)

func unequip_item(equipment_slot:String) -> void:
	if inventory.items.size() == inventory.max_slots: return
	inventory.add_item(equipment[equipment_slot])
	equipment.erase(equipment_slot)
