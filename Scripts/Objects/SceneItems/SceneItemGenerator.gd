class_name SceneItemGenerator
extends Object

enum SCENE_ITEM {
	PASSPORT,
	GLASS_EYE,
	BOOK_1,
	BOOK_2,
	BOOK_3,
	BOOK_4,
	BOOK_5,
	BOOK_6,
	BOOK_7,
	BOOK_8,
	BOOK_KEY,
	TUMBA,
	KEYHOLE,
	FLASHLIGHT,
	GUN,
	KEY_BOOKSHELF,
	CIGARETTES,
	TEA,
	PHOTO,
	COAT,
	RAG,
	NONE
}

static func generate(item : SCENE_ITEM) -> SceneItemBase:
	match item:
		SCENE_ITEM.PASSPORT:
			return SceneItemPassport.new()
		SCENE_ITEM.GLASS_EYE:
			return SceneItemGlassEye.new()
		SCENE_ITEM.BOOK_1:
			return SceneItemBook1.new()
		SCENE_ITEM.BOOK_2:
			return SceneItemBook2.new()
		SCENE_ITEM.BOOK_3:
			return SceneItemBook3.new()
		SCENE_ITEM.BOOK_4:
			return SceneItemBook4.new()
		SCENE_ITEM.BOOK_5:
			return SceneItemBook5.new()
		SCENE_ITEM.BOOK_6:
			return SceneItemBook6.new()
		SCENE_ITEM.BOOK_7:
			return SceneItemBook7.new()
		SCENE_ITEM.BOOK_8:
			return SceneItemBook8.new()
		SCENE_ITEM.BOOK_KEY:
			return SceneItemBookKey.new()
		SCENE_ITEM.TUMBA:
			return SceneItemTumba.new()
		SCENE_ITEM.KEYHOLE:
			return SceneItemKeyhole.new()
		SCENE_ITEM.FLASHLIGHT:
			return SceneItemFlashlight.new()
		SCENE_ITEM.GUN:
			return SceneItemGun.new()
		SCENE_ITEM.KEY_BOOKSHELF:
			return SceneItemKeyBookshelf.new()
		SCENE_ITEM.CIGARETTES:
			return SceneItemCigarettes.new()
		SCENE_ITEM.TEA:
			return SceneItemTea.new()
		SCENE_ITEM.PHOTO:
			return SceneItemPhoto.new()
		SCENE_ITEM.COAT:
			return SceneItemCoat.new()
		SCENE_ITEM.RAG:
			return SceneItemRag.new()
		SCENE_ITEM.NONE:
			return SceneItemBase.new()
	
	printerr("GENERATED UNSOPORTED SCENE ITEM")
	return SceneItemBase.new()

# SKIP GENERATION
