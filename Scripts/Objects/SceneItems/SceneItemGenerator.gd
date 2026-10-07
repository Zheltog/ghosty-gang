class_name SceneItemGenerator
extends Object

enum SCENE_ITEM {
	PASSPORT = 0,
	GLASS_EYE = 1,
	BOOK_1 = 2,
	BOOK_2 = 3,
	BOOK_3 = 4,
	BOOK_4 = 5,
	BOOK_5 = 6,
	BOOK_6 = 7,
	BOOK_7 = 8,
	BOOK_8 = 9,
	BOOK_KEY = 10,
	TUMBA = 11,
	KEYHOLE = 12,
	FLASHLIGHT = 13,
	GUN = 14,
	KEY_BOOKSHELF = 15,
	CIGARETTES = 16,
	TEA = 17,
	PHOTO = 18,
	COAT = 19,
	RAG = 20,
	NONE = 21,
	CHARACTER = 22
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
		SCENE_ITEM.CHARACTER:
			return SceneItemCharacter.new()
	
	printerr("GENERATED UNSOPORTED SCENE ITEM")
	return SceneItemBase.new()

# SKIP GENERATION
