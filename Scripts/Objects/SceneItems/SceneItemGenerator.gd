class_name SceneItemGenerator
extends Object

enum SCENE_ITEM {
	SALT,
	PEPPER
}

static func generate(item : SCENE_ITEM) -> SceneItemBase:
	match item:
		SCENE_ITEM.SALT:
			return SceneItemSalt.new()
		SCENE_ITEM.PEPPER:
			return SceneItemPepper.new()
	
	printerr("GENERATED UNSOPORTED SCENE ITEM")
	return SceneItemBase.new()

# SKIP GENERATION
