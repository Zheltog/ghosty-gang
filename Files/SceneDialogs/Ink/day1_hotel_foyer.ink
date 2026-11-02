// День 1. Фойе снова. Сигареты у хозяйки или уход в магазин.
// Водитель наверху: голос есть, на сцене его нет.

// TODO: актуализировать!

# story: hotel_foyer
# load: has_cigarette, has_cigarette_pack, hotel_phase, from_theft
# save: has_cigarette, has_cigarette_pack, hotel_phase, from_theft, exit

VAR has_cigarette = false
VAR has_cigarette_pack = false
VAR hotel_phase = 0
VAR from_theft = false
VAR exit = ""

-> foyer

=== foyer ===
Хозяйка сидит за стойкой. # window:default # thought # char:landlady # anim:bored
* [Спросить про сигареты.]
	-> ask_smokes

=== ask_smokes ===
Сигареты нет у вас? # response # char:detective # skippable:false
Нет. # window:default # char:landlady # skippable:false
Из-под журнала торчит край пачки. Рядом лежит зажигалка. # thought
А это? # response # char:detective # skippable:false
Это мои. # char:landlady # skippable:false
Я куплю. # response # char:detective # skippable:false
Не продаю. # char:landlady # anim:sharp # skippable:false
-> pressure

=== pressure ===
Сверху снова раздаётся удар. # window:default # thought
+ [Одну хотя бы дайте.]
	Одну хотя бы дайте. # response # char:detective # skippable:false
	Мужчина. Вы меня слышите вообще? Не дам. # window:default # char:landlady # anim:sharp # skippable:false
	Она снова утыкается в журнал. # thought # char:landlady
	-> pressure
* [Ладно. Где у вас магазин ближайший?]
    Хозяйка закатывает глаза. # thought # char:landlady
    На звезде на гвозде поищите. # window:default # char:landlady # skippable:false
    -> pressure
* [Слышали? Он там телевизор ломает.]
	Слышали? Он там телевизор ломает. # response # char:detective # skippable:false
	-> lie

=== lie ===
В смысле — ломает? # window:default # char:landlady # anim:alert # skippable:false
Сказал, мешает ему. Я стук слышал. # response # char:detective # skippable:false
Как пить — так больной. Как вещи чужие ломать — сразу здоровый. # char:landlady # anim:angry # skippable:false
Она отодвигает журнал и выбирается из-за стойки. # thought # char:landlady
Семён! Ты чего там устроил?! # char:landlady # skippable:false
Не дожидаясь ответа, хозяйка идёт к лестнице. # thought # away:landlady
Ты слышишь тяжёлые шаги, затем — стук в дверь наверху. # thought
-> pack

=== pack ===
Пачка осталась на стойке. # window:default # thought
* [Незаметно вытащить одну сигарету.]
	Ты вытягиваешь сигарету. # thought
	~ has_cigarette = true
	-> upstairs_shout
* [Забрать всю пачку.]
	Ты убираешь пачку в карман. # thought
	~ has_cigarette_pack = true
	-> upstairs_shout

=== upstairs_shout ===
Ну? Где сломал? Показывай! # window:default # char:landlady # skippable:false
Чего показывать-то?.. # char:driver # skippable:false
* [Подняться к водителю.]
	~ from_theft = true
	~ exit = "hotel_interview"
	-> END
