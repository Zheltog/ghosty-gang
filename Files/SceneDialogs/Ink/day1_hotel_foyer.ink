// День 1. Фойе снова. Сигареты у хозяйки или уход в магазин.
// Водитель наверху: голос есть, на сцене его нет.

# story: hotel_foyer
# load: has_cigarette, hotel_phase, from_theft
# save: has_cigarette, hotel_phase, from_theft, exit

VAR has_cigarette = false
VAR hotel_phase = 0
VAR from_theft = false
VAR exit = ""

-> foyer

=== foyer ===
Хозяйка сидит за стойкой. # window:default # thought # char:landlady # anim:bored
* [Спросить про сигареты.]
	-> ask_smokes
+ [Дойти до магазина.]
	~ hotel_phase = 2
	~ exit = "shop"
	-> END

=== ask_smokes ===
Сигареты нет у вас? # response # char:detective
Нет. # window:default # char:landlady
Из-под журнала торчит край пачки. Рядом лежит зажигалка. # thought
А это? # response # char:detective
Это мои. # char:landlady
Я куплю. # response # char:detective
Не продаю. # char:landlady # anim:sharp
-> pressure

=== pressure ===
Сверху снова раздаётся удар. # window:default # thought
+ [Одну хотя бы дайте.]
	Одну хотя бы дайте. # response # char:detective
	Мужчина. Вы меня слышите вообще? Не дам. # window:default # char:landlady # anim:sharp
	Она снова утыкается в журнал. # thought # char:landlady
	-> pressure
* [Слышали? Он там телевизор ломает.]
	Слышали? Он там телевизор ломает. # response # char:detective
	-> lie

=== lie ===
В смысле — ломает? # window:default # char:landlady # anim:alert
Сказал, мешает ему. Я стук слышал. # response # char:detective
Как пить — так больной. Как вещи чужие ломать — сразу здоровый. # char:landlady # anim:angry
Она отодвигает журнал и выбирается из-за стойки. # thought # char:landlady
Семён! Ты чего там устроил?! # char:landlady
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
	~ has_cigarette = true
	-> upstairs_shout
* [Не трогать пачку.]
	-> left_pack

=== upstairs_shout ===
Ну? Где сломал? Показывай! # window:default # char:driver
Чего показывать-то?.. # char:driver
* [Подняться к водителю.]
	~ from_theft = true
	~ exit = "hotel_interview"
	-> END
+ [Пойти на улицу.]
	~ hotel_phase = 2
	~ exit = "map"
	-> END

=== left_pack ===
Ты отходишь от стойки. Пачка остаётся рядом с раскрытым журналом. # window:default # thought
+ [Пойти на улицу.]
	~ hotel_phase = 2
	~ exit = "map"
	-> END
