class_name DossierTextBox

extends TextBoxWithOptions

const _options_path := "TextureRect/DossierOptions"
const _options_count := 6

func _ready() -> void:
	super._ready()
	_assign_option_holder(_options_count, _options_path)
	var holder: Node = _option_holders.get(_options_count)
	if holder == null:
		printerr("DossierTextBox: no holder at ", _options_path)
		return
	var manager := get_parent() as DialogWindowManager
	for child in holder.get_children():
		var button := child as BoxOptionButton
		if button:
			button.set_window_manager(manager)
	holder.hide()

func _show_options(options: Array) -> void:
	var holder: Node = _option_holders.get(_options_count)
	if holder == null or options.is_empty() or options.size() > _options_count:
		super._show_options(options)
		return
	_are_options_shown = true
	var buttons: Array[BoxOptionButton] = []
	for child in holder.get_children():
		var button := child as BoxOptionButton
		if button:
			buttons.append(button)
	for i in buttons.size():
		var button := buttons[i]
		if i < options.size():
			var option = options[i]
			button.reset_visual()
			button.set_text(option.GetText())
			button.id = option.GetIndex()
		else:
			button.hide()
	holder.show()
