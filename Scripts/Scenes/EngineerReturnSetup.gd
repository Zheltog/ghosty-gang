extends Node

const NIGHT_FADE_SECONDS := 8.0

const ITEMS: Array[InventoryItemGenerator.INVENTORY_ITEM] = [
	InventoryItemGenerator.INVENTORY_ITEM.KEY_BOOKSHELF,
	InventoryItemGenerator.INVENTORY_ITEM.GUN,
	InventoryItemGenerator.INVENTORY_ITEM.PASSPORT,
]

func _ready() -> void:
	var house := get_parent() as HouseScenePreview
	if house != null and house.scene_states != null:
		house.scene_states.first_state = null
	call_deferred("_begin")

func _begin() -> void:
	var house := get_parent() as HouseScenePreview
	if house == null or house.scene_states == null:
		printerr("EngineerReturnSetup: house scene is missing")
		return
	_open_shelf(house)
	_take_storage_items(house)
	_give_items(house)
	InkVariableStore.set_value("saw_passports", true)
	InkVariableStore.set_value("coat_key_taken", true)
	house.scene_states.set("_storage_hum", true)
	CommonAudioProcessor.transition_music_by_name("night", NIGHT_FADE_SECONDS)
	var tea := house.scene_states.get_node_or_null("Welcome/PassportTimer/TeaReady") as SceneDialogState
	if tea == null:
		printerr("EngineerReturnSetup: TeaReady state is missing")
		return
	tea.activate()

func _open_shelf(house: HouseScenePreview) -> void:
	var shelf := house.find_child("Shelfs", true, false) as CustomBookshelfSceneItemUI
	if shelf == null:
		printerr("EngineerReturnSetup: shelf is missing")
		return
	StateManager.set_state(CustomBookshelfSceneItemUI.STATE_BOOK_REMOVED, true)
	StateManager.set_state(CustomBookshelfSceneItemUI.STATE_KEY_TURNED, true)
	StateManager.set_state(CustomBookshelfSceneItemUI.STATE_OPEN, true)
	var book := shelf.get_node_or_null("Books5") as CanvasItem
	if book:
		book.hide()
	shelf._remove_keyhole()
	shelf._disable_books()
	shelf._apply_open(true)

func _take_storage_items(house: HouseScenePreview) -> void:
	for child_name in ["Passport", "Gun"]:
		var item := house.room_child("storage", child_name)
		if item:
			item.queue_free()

func _give_items(house: HouseScenePreview) -> void:
	var inventory := house.get_node_or_null("Inventory") as Inventory
	if inventory == null or inventory.inventory_holder == null:
		printerr("EngineerReturnSetup: inventory is missing")
		return
	for item_id in ITEMS:
		if not inventory.has_item(item_id):
			inventory.inventory_holder.add_item(item_id)
