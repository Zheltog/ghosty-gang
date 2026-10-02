// День 1. Гостиница «Виктория»: хозяйка, номер, Семён Гало.
// Персонажи: landlady, detective, driver.
// hotel_phase: 0 — первый заход, 2 — водитель ждёт сигарету, 3 — разговор закончен.
// Сигареты можно принести из этой сцены или из day1_shop.ink.

# load: has_cigarette, knows_sim, hotel_phase, saw_room
# save: has_cigarette, knows_sim, hotel_phase, saw_room

VAR has_cigarette = false
VAR knows_sim = false
VAR hotel_phase = 0
VAR saw_room = false
VAR from_theft = false
VAR room_return = ""

-> begin

=== begin ===
{hotel_phase >= 3:
	-> END
}
{hotel_phase >= 2 and has_cigarette:
	-> give_cigarette
}
{hotel_phase >= 2:
	-> after_driver
}
-> lobby

=== lobby ===
Дверь захлопывается за твоей спиной так громко, что ты вздрагиваешь. Сильнейший сквозняк пронесся по стойке ресепшена, перелистав страницы лежащего там журнала. Прическе хозяйки, замечаешь ты, тоже досталось. Или тут дело не в сквозняке? # window:default # char:detective # anim:startle
Закрывай, закрывай, чего встал! # char:landlady # anim:hostile
В лифте родился? # char:landlady
Она смотрит на тебя с явной враждебностью.
Остановиться можно? Почем? # response # char:detective
Две двести. Удобства общие в коридоре. Вверх по лестнице, второй номер справа. # char:landlady
С завтраком? # response # char:detective
Ага, щас. А больше ниче не надо? # char:landlady # anim:annoyed
У вас водитель остановился. Семён. # response # char:detective
Хозяйка закатывает глаза. # char:landlady # anim:eye_roll
В двести четвертом. Передай, если снова в номере курить будет — выкину на мороз к чер-ртовой бабушке. # char:landlady
-> upstairs

=== upstairs ===
{saw_room:
	Больше тут делать нечего. # window:default
- else:
	Ты поднимаешься на второй этаж. # window:default
}
* [Пойти к себе.]
	~ room_return = "upstairs"
	-> room
* [Заглянуть к водителю.]
	-> driver_first

=== room ===
{saw_room:
	{room_return == "smoke":
		-> after_driver
	}
	-> upstairs
}
Ты проворачиваешь ключ в замке. Приходится повозиться: замок проржавел. В конце концов дверь со стоном открывается. # window:default
Перед твоими глазами узкая и длинная комната, в конце которой находятся кровать (скорее койка) и тумбочка. В комнате пыльно. Одеяло свернуто, а белье просто лежит рядом.
У нас в СИЗО в девяностых и то уютнее было. # response # char:detective
Ты бросаешь портфель на кровать и выходишь из комнаты.
~ saw_room = true
{room_return == "smoke":
	-> after_driver
}
-> upstairs

=== driver_first ===
Из-за двери номера 204 доносится телевизор. После второго стука звук пропадает. # window:default
Чего? # char:driver # anim:gruff
Семён Гало? # response # char:detective
Ну. # char:driver
Можно с вами поговорить? # response # char:detective
Дверь открывается. Водитель, в одной майке, смотрит на тебя недобро. За его спиной смятая постель и закрытые шторы. В комнате пахнет перегаром и табаком.
Чего пришел? Заплачено за номер. # char:driver
Я не из гостиницы. Мальчика ищу. Возможно, вы его сюда привезли. # response # char:detective
Семён смеряет тебя взглядом и молча уходит в глубь комнаты к телевизору и стучит по его корпусу. После каждого удара в воздух поднимается облачко пыли. # char:driver
Не включается никак, зараза. # char:driver # anim:sullen
Ты достаёшь фотографию мальчика и протягиваешь её водителю. Семён будто ее не замечает.
Куришь? # char:driver
Не курю. # response # char:detective
Тогда потом. # char:driver
Он начинает закрывать дверь.
Подождите. Мне только узнать, был он в автобусе или нет. # response # char:detective
Я сказал — потом. # char:driver
Когда потом? # response # char:detective
Семён отпускает ручку и возвращается в комнату. Ты остаёшься на пороге. Он берёт со стола пачку, заглядывает внутрь и бросает обратно.
Как покурю. # char:driver
Ваш сменщик сказал, вы здесь остановились. С женой поругались. # response # char:detective
Семён садится на край кровати. # char:driver # anim:tired
Развелись мы. # char:driver
Он сказал — поругались. # response # char:detective
Я ему так и сказал. # char:driver
Он долго трёт лицо ладонями.
Я вас не задержу. Посмотрите фотографию. # response # char:detective
Ты протягиваешь её. Семён отводит глаза.
Не могу я сейчас. # char:driver
Ребёнок пропал, Семён. # response # char:detective
Слышал я. # char:driver
Он поднимает на тебя глаза.
Принеси сигарет. Покурю, голову соберу. Тогда спрашивай. # char:driver
И поговорим? # response # char:detective
Поговорим. Дверь прикрой. Дует. # char:driver
Слышь. # char:driver
Ты оборачиваешься.
-> after_driver

=== after_driver ===
~ hotel_phase = 2
{room_return == "smoke":
	Больше тут делать нечего. # window:default
- else:
	Хозяйке не надо говорить. Она опять начнёт. # window:default # char:driver
}
+ [Пойти к себе в номер.]
	~ room_return = "smoke"
	-> room
+ [Спуститься в фойе.]
	-> foyer

=== foyer ===
Хозяйка сидит за стойкой, подперев щёку кулаком. На твоё появление она не реагирует. # window:default # char:landlady # anim:bored
* [Спросить про сигареты.]
	-> ask_smokes
+ [Дойти до магазина.]
	~ hotel_phase = 2
	-> END

=== ask_smokes ===
Сигареты нет у вас? # response # char:detective
Нет. # window:default # char:landlady
Из-под журнала торчит край пачки. Рядом лежит зажигалка.
А это? # response # char:detective
Хозяйка прослеживает твой взгляд.
Это мои. # char:landlady
Я куплю. # response # char:detective
Не продаю. # char:landlady # anim:sharp
Сверху снова раздаётся удар. Хозяйка поднимает глаза к потолку.
-> pressure

=== pressure ===
Она смотрит на тебя. # window:default # char:landlady
+ [Одну хотя бы дайте.]
	Одну хотя бы дайте. # response # char:detective
	Мужчина. Вы меня слышите вообще? Не дам. # window:default # char:landlady # anim:sharp
	Она снова утыкается в журнал.
	-> pressure
* [Слышали? Он там телевизор ломает.]
	Слышали? Он там телевизор ломает. # response # char:detective
	-> lie

=== lie ===
Хозяйка отнимает руку от щеки. # window:default
В смысле — ломает? # char:landlady # anim:alert
Сказал, мешает ему. Я стук слышал. # response # char:detective
Как пить — так больной. Как вещи чужие ломать — сразу здоровый. # char:landlady # anim:angry
Она отодвигает журнал и выбирается из-за стойки.
Семён! Ты чего там устроил?! # char:landlady
Не дожидаясь ответа, хозяйка идёт к лестнице. Ты слышишь тяжёлые шаги, затем — стук в дверь наверху.
-> pack

=== pack ===
Пачка осталась на стойке. # window:default
* [Незаметно вытащить одну сигарету.]
	Ты вытягиваешь сигарету.
	~ has_cigarette = true
	-> upstairs_shout
* [Забрать всю пачку.]
	Ты убираешь пачку в карман.
	~ has_cigarette = true
	-> upstairs_shout
* [Не трогать пачку.]
	-> left_pack

=== upstairs_shout ===
Ну? Где сломал? Показывай! # window:default # char:landlady
Чего показывать-то?.. # char:driver
* [Подняться к водителю.]
	~ from_theft = true
	-> give_cigarette
+ [Пойти на улицу.]
	~ hotel_phase = 2
	-> END

=== left_pack ===
Ты отходишь от стойки. Пачка остаётся рядом с раскрытым журналом. # window:default
+ [Пойти на улицу.]
	~ hotel_phase = 2
	-> END

=== give_cigarette ===
{from_theft:
	Ты поднимаешься по лестнице навстречу хозяйке гостиницы, стараясь не пересекаться с ней глазами. # window:default
	Хамло! Псих! # char:landlady # anim:angry
	У двери тебя встречает водитель.
	Стерва! Нет бы мастера вызвать, технику починить. Надо на честного мужика гнать. # char:driver # anim:angry
- else:
	У двери тебя встречает водитель. # window:default
}
Держи свою сигарету. # response # char:detective
Водитель хватает сигарету из твоих рук и ловко заправляет ее за ухо.
Проходь. Садись. # char:driver
Ты проходишь в номер и садишься на кровать. Водитель закрывает дверь за твоей спиной на щеколду. Он наклоняется к груде одежды, лежащей в углу, достает оттуда зажигалку и закуривает.
Окно?.. # response # char:detective
Дурак, что ли? Застудимся. # char:driver # anim:gruff
Он устраивается рядом с тобой и сладко затягивается. Вы сидите молча, пока он докуривает. Вдруг телевизор включается сам собой.
На экране неровная картинка отечественного сериала. Водитель явно доволен таким чудесам. # char:driver # anim:pleased
Лучшего момента для вопросов может и не быть. Ты снова суешь ему фотографию.
-> interview

=== interview ===
Ну что, Семён? Видел мальчишку? # response # char:detective
Пацана-то? Да, подвозил. Смешной он. Воробышек. # window:default # char:driver
Вы с ним говорили? # response # char:detective
Ну так. Рассказывал о бабке своей. Ну, в поселке которая у нас. К ней ехал. # char:driver
Знаешь ее? # response # char:detective
Да он ни имени, ни должности не назвал. Бабушка как все бабушки. Блины, мол, жарит. Рассаду выращивает. В телефоне своем постоянно путает что-то. # char:driver # anim:shrug
Семён разводит руками в стороны.
Людмила Игоревна Куликова. Раньше чиновница была. # response # char:detective
Куликова? # char:driver # anim:frown
Он хмурит брови.
Не помню такую. # char:driver
Ладно. А мальчик еще говорил что-то? # response # char:detective
Планы строил. Что с мамой летом на Майорку полетят. Мажор, что ли? # char:driver
Типа того. А как с автобуса сошел? Встречал его кто-нибудь? # response # char:detective
Нет. Пустая остановка была. # char:driver
И ты его отпустил так просто? # response # char:detective
А что я? У меня маршрут. # char:driver
Понятно. # response # char:detective
А что с мальком-то? # char:driver
Пропал. Ты последний его видел. # response # char:detective
Последний? Ё-маё… До бабки что ли не дошел? # char:driver # anim:shocked
Она не в Вязи тогда была. # response # char:detective
Водитель сразу сник и уставился в пол. # char:driver # anim:downcast
Узнаешь что-то — звони мне. # response # char:detective
А у тебя ловит? # char:driver
Вообще-то нет. Думал, из-за бури. # response # char:detective
Тут только один оператор ловит нормально. Поищи симку, жить легче будет. # char:driver
~ knows_sim = true
Учту. # response # char:detective
Удачи в поисках. Найдётся пацан. Вязь маленькая, не заблудишься. # char:driver
Уж надеюсь. # response # char:detective
Водитель встаёт, чтобы закрыть за тобой в дверь, но останавливается на полпути.
Начальник. А ты к Шнейдеру ходил уже? # char:driver # anim:wary
Ты морщишься. # char:detective # anim:wince
Он тут что ли до сих пор? # response # char:detective
А куда он денется? Без него тут ни один вопрос не решается. # char:driver
Вот поэтому у вас все и идёт через жопу. # response # char:detective
У тебя с ним проблемы какие-то? # char:driver
Мягко сказано. # response # char:detective
А ты все равно сходи. Если кто и поможет, то только он. # char:driver
Обойдусь. # response # char:detective
-> street

=== street ===
~ hotel_phase = 3
Ты на улице. # window:default
* [Пойти к бабушке.]
	// В сценарии ветка не прописана.
	-> END
* [Пойти к шестерке.]
	// В сценарии ветка не прописана.
	-> END
* [Пойти в магазин.]
	// Диалог магазина — day1_shop.ink
	-> END
