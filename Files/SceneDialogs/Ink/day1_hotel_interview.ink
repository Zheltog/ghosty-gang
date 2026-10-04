// День 1. Номер 204. Семён курит и отвечает про Женю.

# story: hotel_interview
# load: from_theft, knows_sim, hotel_phase
# save: knows_sim, hotel_phase, exit

VAR from_theft = false
VAR knows_sim = false
VAR hotel_phase = 0
VAR exit = ""

-> give_cigarette

=== give_cigarette ===
{from_theft:
	Ты поднимаешься по лестнице навстречу хозяйке. # window:default # thought
	Хамло! Псих! # char:landlady # anim:angry # skippable:false
	У двери тебя встречает водитель. # thought # char:driver # away:landlady
	Стерва! Нет бы мастера вызвать, технику починить. # char:driver # anim:angry # skippable:false
	Надо на честного мужика гнать. # char:driver # skippable:false
- else:
	У двери тебя встречает водитель. # window:default # thought # char:driver
}
Держи свою сигарету. # response # char:detective # skippable:false
Водитель хватает сигарету из твоих рук и ловко заправляет ее за ухо. # thought # char:driver
Проходь. Садись. # char:driver # skippable:false
Ты проходишь в номер и садишься на кровать. # thought
Водитель закрывает дверь за твоей спиной на щеколду. # thought # char:driver
Он наклоняется к груде одежды в углу, достает зажигалку и закуривает. # thought # char:driver
Окно?.. # response # char:detective # skippable:false
Дурак, что ли? Застудимся. # char:driver # anim:gruff # skippable:false
Он устраивается рядом и сладко затягивается. Вы сидите молча, пока он докуривает. # thought # char:driver
Вдруг телевизор включается сам собой. # thought
На экране неровная картинка отечественного сериала. # thought # char:driver # anim:pleased
Лучшего момента для вопросов может и не быть. # thought
Ты снова суешь ему фотографию. # thought
-> interview

=== interview ===
Ну что, Семён? Видел мальчишку? # response # char:detective # skippable:false
Пацана-то? Да, подвозил. Смешной он. Воробышек. # window:default # char:driver # skippable:false
Вы с ним говорили? # response # char:detective # skippable:false
Ну так. Рассказывал о бабке своей. Ну, в поселке которая у нас. # char:driver # skippable:false
К ней ехал. # char:driver # skippable:false
Знаешь ее? # response # char:detective # skippable:false
Да он ни имени, ни должности не назвал. # char:driver # anim:shrug # skippable:false
Бабушка как все бабушки. Блины, мол, жарит. Рассаду выращивает. # char:driver # skippable:false
В телефоне своем постоянно путает что-то. # char:driver # skippable:false
Людмила Игоревна Куликова. Раньше чиновница была. # response # char:detective # skippable:false
Куликова? # char:driver # anim:frown # skippable:false
Не помню такую. # char:driver # skippable:false
Ладно. А мальчик еще говорил что-то? # response # char:detective # skippable:false
Планы строил. Что с мамой летом на Майорку полетят. Мажор, что ли? # char:driver # skippable:false
Типа того. А как с автобуса сошел? # response # char:detective # skippable:false
Встречал его кто-нибудь? # response # char:detective # skippable:false
Нет. Пустая остановка была. # char:driver # skippable:false
И ты его отпустил так просто? # response # char:detective # skippable:false
А что я? У меня маршрут. # char:driver # skippable:false
Понятно. # response # char:detective # skippable:false
А что с мальком-то? # char:driver # skippable:false
Пропал. Ты последний его видел. # response # char:detective # skippable:false
Последний? Ё-маё… До бабки что ли не дошел? # char:driver # anim:shocked # skippable:false
Она не в Вязи тогда была. # response # char:detective # skippable:false
Узнаешь что-то — звони мне. # response # char:detective # skippable:false
А у тебя ловит? # char:driver # anim:downcast # skippable:false
Вообще-то нет. Думал, из-за бури. # response # char:detective # skippable:false
Тут только один оператор ловит нормально. Поищи симку, жить легче будет. # char:driver # skippable:false
~ knows_sim = true
Учту. # response # char:detective # skippable:false
Удачи в поисках. Найдётся пацан. Вязь маленькая, не заблудишься. # char:driver # skippable:false
Уж надеюсь. # response # char:detective # skippable:false
Начальник. А ты к Шнейдеру ходил уже? # char:driver # anim:wary # skippable:false
Он тут что ли до сих пор? # response # char:detective # anim:wince # skippable:false
А куда он денется? Без него тут ни один вопрос не решается. # char:driver # skippable:false
Вот поэтому у вас все и идёт через жопу. # response # char:detective # skippable:false
У тебя с ним проблемы какие-то? # char:driver # skippable:false
Мягко сказано. # response # char:detective # skippable:false
А ты все равно сходи. Если кто и поможет, то только он. # char:driver # skippable:false
Обойдусь. # response # char:detective # skippable:false
-> street

=== street ===
~ hotel_phase = 3
Ты на улице. # window:default # thought # away:driver
* [Пойти к бабушке.]
	// В сценарии ветка не прописана.
	~ exit = "map"
	-> END
* [Пойти к шестерке.]
	// В сценарии ветка не прописана.
	~ exit = "map"
	-> END
* [Пойти в магазин.]
	~ exit = "shop"
	-> END
