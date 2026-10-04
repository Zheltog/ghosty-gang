EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)

# story: passport

~ godot_1("Inventory", "add_item_str", "passport")
~ godot("SceneItemPassport", "disappear")
~ godot("HouseScenePreview", "notice_passports")
Целая куча паспортов советского образца. В каждом - фото Владислава. Или, лучше сказать, хозяина квартиры: имена отличаются. Владислав Хаит, Игорь Ткачёв, Валентин Коваль, Пётр Шмидт… # window:default # skippable:true # thought
Дело принимает странный оборот. # thought # skippable:true
~ godot("HouseScenePreview", "silence_kitchen")
Вы устроились? # window:another_room_left # char:engineer # skippable:false
~ godot("HouseScenePreview", "schedule_engineer_arrival")
-> END
