// День ?. Путь к Захару, попытка попасть в случайный дом.
// Персонажи: detective.
// Мысли и ремарки — # thought, их говорит none.
// Дальше: road_to_zakhar_random_street_2.ink

EXTERNAL godot_1(target_class, method, arg)

-> random_house

=== random_house ===
Ты подходишь к подъезду и наудачу набираешь номер в домофоне. # thought
Ответа нет. # thought
Набираешь второй, третий. # thought
Без толку. # thought
Ты с силой хлопаешь ладонью по двери. # thought
Твою мать! # response # char:detective # skippable:false
~ godot_1("RoadToZakharScenePreview", "load_room", "street_2")
-> END
