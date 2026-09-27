class_name SceneItemGenerator
extends Object

enum SCENE_ITEM {
	SALT,
	BOTTLE,
	PEPPER,
	PASSPORT,
	GLASS_EYE,
	HOUSE_DOOR,
	DOOR,
	NONE
}

static func generate(item : SCENE_ITEM) -> SceneItemBase:
	match item:
		SCENE_ITEM.SALT:
			return SceneItemSalt.new()
		SCENE_ITEM.BOTTLE:
			return SceneItemBottle.new()
		SCENE_ITEM.PEPPER:
			return SceneItemPepper.new()
		SCENE_ITEM.PASSPORT:
			return SceneItemPassport.new()
		SCENE_ITEM.GLASS_EYE:
			return SceneItemGlassEye.new()
		SCENE_ITEM.HOUSE_DOOR:
			return SceneItemHouseDoor.new()
		SCENE_ITEM.DOOR:
			return SceneItemDoor.new()
		SCENE_ITEM.NONE:
			return SceneItemBase.new()
	
	printerr("GENERATED UNSOPORTED SCENE ITEM")
	return SceneItemBase.new()

# SKIP GENERATION
