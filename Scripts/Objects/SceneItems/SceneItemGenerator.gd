class_name SceneItemGenerator
extends Object

enum SCENE_ITEM {
	SALT,
	BOTTLE,
	PEPPER,
	DOOR,
	TO_KITCHEN,
	TO_LIVING_ROOM
}

static func generate(item : SCENE_ITEM) -> SceneItemBase:
	match item:
		SCENE_ITEM.SALT:
			return SceneItemSalt.new()
		SCENE_ITEM.BOTTLE:
			return SceneItemBottle.new()
		SCENE_ITEM.PEPPER:
			return SceneItemPepper.new()
		SCENE_ITEM.DOOR:
			return SceneItemDoor.new()
		SCENE_ITEM.TO_KITCHEN:
			return SceneItemToKitchen.new()
		SCENE_ITEM.TO_LIVING_ROOM:
			return SceneItemToLivingRoom.new()
	
	printerr("GENERATED UNSOPORTED SCENE ITEM")
	return SceneItemBase.new()

# SKIP GENERATION
