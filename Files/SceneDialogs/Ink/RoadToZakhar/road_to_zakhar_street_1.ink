// День ?. Путь к Захару, выход с пустыря на улицу.
// Персонажи: detective.
// Мысли и ремарки — # thought, их говорит none.
// Дальше: road_to_zakhar_random_house.ink

EXTERNAL godot_1(target_class, method, arg)

-> street_1

=== street_1 ===
Даже когда ты выходишь с пустыря и идешь по улице. # thought
Где все? # response # char:detective # skippable:false
Солнце высоко, времени уже часов десять по-любому. # response # char:detective # skippable:false
~ godot_1("RoadToZakharScenePreview", "load_room", "random_house")
-> END
