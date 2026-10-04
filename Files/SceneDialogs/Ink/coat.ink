EXTERNAL godot_1(target_class, method, arg)
# load: coat_key_taken
# save: coat_key_taken

VAR coat_key_taken = false

{coat_key_taken:
	В карманах пусто. Ключ я уже забрал. # window:default # skippable:true # thought
	-> END
}

Немного пошарив в карманах я нашел ключ. # window:default # skippable:true # thought
Верну потом на место, пока хозяин не будет против. # skippable:true # thought
~ godot_1("Inventory", "add_item_str", "key_bookshelf")
~ coat_key_taken = true
-> END
