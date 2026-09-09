class_name SceneItemGenerator
extends Object

enum SCENE_ITEM {
	SALT,
	PEPPER,
	DOOR
}

static func generate(item : SCENE_ITEM) -> SceneItemBase:
	match item:
		SCENE_ITEM.SALT:
			return SceneItemSalt.new()
		SCENE_ITEM.PEPPER:
			return SceneItemPepper.new()
		SCENE_ITEM.DOOR:
			return SceneItemDoor.new()
	
	printerr("GENERATED UNSOPORTED SCENE ITEM")
	return SceneItemBase.new()

# SKIP GENERATION
