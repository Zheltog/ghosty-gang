EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
EXTERNAL godot_2(target_class, method, arg1, arg2)

# story: passport

~ godot("Inventory", "unequip_item")
~ godot("Inventory", "close")
~ godot_1("Inventory", "add_item_str", "passport")
~ godot("SceneItemPassport", "disappear")
~ godot_2("CommonAudioProcessor", "transition_music_by_name", "hum", 3.0)
Целая куча паспортов советского образца. В каждом - фото Владислава. Или, лучше сказать, хозяина квартиры: имена отличаются. Владислав Хаит, Игорь Ткачёв, Валентин Коваль, Пётр Шмидт… # window:default # skippable:true # thought
Дело принимает странный оборот. # thought # skippable:true
~ godot_1("SceneDialogManager", "process_event", "silence_kitchen")
Вы устроились? # window:another_room_left # char:engineer # skippable:false
-> END
