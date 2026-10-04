class_name DossierTextBox

extends TextBoxWithOptions

const _options_path := "TextureRect/DossierOptions"
const _options_count := 7
const _slots := {
	"Женя Куликов": &"Zhenya",
	"Степан Куликов": &"Stepan",
	"Эмма Куликова": &"Emma",
	"Людмила Куликова": &"Lyudmila",
	"Вадим Титов": &"Vadim",
	"Семён Гало": &"Semyon",
	"Достаточно": &"Enough",
}

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
	for child in holder.get_children():
		if child is BoxOptionButton:
			child.hide()
	for option in options:
		var slot: StringName = _slots.get(str(option.GetText()).strip_edges(), &"")
		var button := holder.get_node_or_null(NodePath(str(slot))) as BoxOptionButton
		if button == null:
			printerr("DossierTextBox: no slot for ", option.GetText())
			continue
		button.reset_visual()
		button.set_text(option.GetText())
		button.id = option.GetIndex()
	holder.show()

func hide_other_options(selected: BoxOptionButton) -> void:
	if selected:
		selected.hide()
