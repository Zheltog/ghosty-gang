// День ?. Путь к Захару, преследование голоса.
// Персонажи: detective, voice.
// Мысли и ремарки — # thought, их говорит none.
// Дальше: road_to_zakhar_street_3.ink

EXTERNAL godot_1(target_class, method, arg)

-> street_2

=== street_2 ===
Ты прислушиваешься, стараясь уловить хоть какой-то шум. # thought
Голоса, машины, птицы, гул проводов. # thought
Да хоть что-нибудь. # thought
…будет нам светить, # char:voice # skippable:false
Мгла уйдет и тучи!.. # char:voice # skippable:false
Ты вскидываешь голову. # thought
Показалось? # thought
Кто не хочет в дружбе жить, # char:voice # skippable:false
Будет мной проучен! # char:voice # skippable:false
Точно, кто-то поет. Не послышалось. # thought
Крякнув, ты бежишь на голос. # thought
Эй! Стой! Стой! Не уходи! # response # char:detective # skippable:false
~ godot_1("RoadToZakharScenePreview", "load_room", "street_3")
-> END
