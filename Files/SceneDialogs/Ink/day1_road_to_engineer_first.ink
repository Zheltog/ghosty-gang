// День 1. Первая дорога к дому Инженера в сопровождении Заводчанина.

# load: has_cigarette_pack, factory_worker_introduced
# save: has_cigarette_pack, factory_worker_introduced

VAR has_cigarette_pack = false
VAR factory_worker_introduced = false

-> street

== street ==
Ты выходишь на улицу. # thought
Мимо проходит шумная компания мужичков в рабочих спецовках. # thought
Ты окликаешь одного из них и показываешь адрес инженера. # thought
А. Это за пустырем.  # char:factory_worker # skippable:false
Мы мимо проходить будем, даешь с нами.  # char:factory_worker # skippable:false
Сигаретки не найдётся, кстати?  # char:factory_worker # skippable:false

{has_cigarette_pack:
    -> cig_choice_with_options
- else:
    -> cig_choice_without_options
}

== cig_choice_with_options ==
* [Вот, держи, последняя]
    -> offering_last
* [Нет, не курю]
    -> sportsman
-> main

== cig_choice_without_options ==
* [Нет, не курю]
    -> sportsman

== sportsman ==
Спортсмен что ли? Ну и ладно. # char:factory_worker # skippable:false
-> main

== offering_last ==
Э нет, последнюю и мент не берёт! # char:factory_worker # skippable:false
* [(Соврать) Бери, у меня ещё пачка есть]
    -> accepting_last
* [Ну и ладно]
    -> main

== accepting_last ==
Ну ладно, давай сюда.  # char:factory_worker # skippable:false
Меня кстати Серёгой звать. Не замёрзнем – сочтёмся!  # char:factory_worker # skippable:false
~ factory_worker_introduced = true
-> main

== main ==
Он отворачивается к другим мужикам и продолжает разговор. # thought
Ты присоединяешься к компании и плетешься в конце. # thought
В беседу заводчан ты особо не вслушиваешься, но до тебя доносятся обрывки туалетных шуток и жалоб на начальство. # thought
Спустя время заводчанин свистит тебе и указывает на дом в отделении. Ты киваешь и сворачиваешь от компании на тропинку ведущую к блочной трехэтажке. # thought
-> END
