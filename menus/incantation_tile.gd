extends TextureButton
class_name IncantationTile

var incantation: Incantation
var original: bool = true

func load_tile(inc:Incantation) -> void:
	if inc != null: incantation = inc
	if inc.name.length() > 0: $PanelContainer/Label.text = inc.name
	if inc.image != null: texture_normal = inc.image

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := TextureRect.new()
	preview.texture = texture_normal
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = Vector2(50,50)
	set_drag_preview(preview)
	return self

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_RIGHT: if not original: queue_free()
