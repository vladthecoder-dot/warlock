extends Control

@onready var invocations_list: VBoxContainer = $InvocationsList
@onready var invocation: HBoxContainer = $InvocationBox
@onready var incantations: HBoxContainer = $IncantationsBox
@onready var save_button: Button = $VBoxContainer/SaveButton
@onready var invocation_name: LineEdit = $VBoxContainer/InvocationName
@onready var active_invocation: Label = $VBoxContainer/ActiveInvocationLabel
var invoker: Invoker
var tile_scene: PackedScene = preload("res://menus/incantation_tile.tscn")

func _ready() -> void:
	save_button.pressed.connect(save_invocation)
	invoker = get_parent() as Invoker
	update_invocations_list()
	invoker.invocations_updated.connect(update_invocations_list)
	invoker.active_updated.connect(func():
		$VBoxContainer/ActiveInvocationLabel.text = invoker.active_invocaton)
	for inc in invoker.available_incantations:
		var tile := tile_scene.instantiate() as IncantationTile
		tile.load_tile(inc)
		incantations.add_child(tile)

func update_invocations_list() -> void:
	for inv in invocations_list.get_children(): inv.queue_free()
	for inv in invoker.saved_invocations:
		var invocation_button = Button.new()
		invocation_button.text = inv
		invocation_button.pressed.connect(func():
			invoker.active_invocaton = invocation_button.text)
		invocations_list.add_child(invocation_button)

func save_invocation() -> void:
	var save_name = invocation_name.text
	if save_name.length() == 0: return
	var new_inv : Array[Incantation]
	for tile in invocation.get_children():
		if tile is IncantationTile: 
			var inc = (tile as IncantationTile).incantation
			new_inv.append(inc)
	invoker.save_invocation(save_name, new_inv)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var rect : Rect2 = invocation.get_global_rect()
	var in_rect := rect.has_point(at_position)
	return typeof(data) == typeof(IncantationTile) and in_rect

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var target_index := invocation.get_child_count()
	for i in range(invocation.get_child_count()):
		var inc := invocation.get_child(i) as Control
		if inc:
			if at_position.x < inc.get_rect().get_center().x:
				target_index = i
				break
	var parent_tile := data as IncantationTile
	var tile := tile_scene.instantiate() as IncantationTile
	tile.original = false
	tile.load_tile(parent_tile.incantation)
	invocation.add_child(tile)
	invocation.move_child(tile, target_index)
	if not parent_tile.original: parent_tile.queue_free()
