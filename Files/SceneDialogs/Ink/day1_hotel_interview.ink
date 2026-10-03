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
	Хамло! Псих! # char:landlady # anim:angry
	У двери тебя встречает водитель. # thought # char:driver # away:landlady
	Стерва! Нет бы мастера вызвать, технику починить. # char:driver # anim:angry
	Надо на честного мужика гнать. # char:driver
- else:
	У двери тебя встречает водитель. # window:default # thought # char:driver
}
Держи свою сигарету. # response # char:detective
Водитель хватает сигарету из твоих рук и ловко заправляет ее за ухо. # thought # char:driver
Проходь. Садись. # char:driver
Ты проходишь в номер и садишься на кровать. # thought
Водитель закрывает дверь за твоей спиной на щеколду. # thought # char:driver
Он наклоняется к груде одежды в углу, достает зажигалку и закуривает. # thought # char:driver
Окно?.. # response # char:detective
Дурак, что ли? Застудимся. # char:driver # anim:gruff
Он устраивается рядом и сладко затягивается. Вы сидите молча, пока он докуривает. # thought # char:driver
Вдруг телевизор включается сам собой. # thought
На экране неровная картинка отечественного сериала. # thought # char:driver # anim:pleased
Лучшего момента для вопросов может и не быть. # thought
Ты снова суешь ему фотографию. # thought
-> interview

=== interview ===
Ну что, Семён? Видел мальчишку? # response # char:detective
Пацана-то? Да, подвозил. Смешной он. Воробышек. # window:default # char:driver
Вы с ним говорили? # response # char:detective
Ну так. Рассказывал о бабке своей. Ну, в поселке которая у нас. # char:driver
К ней ехал. # char:driver
Знаешь ее? # response # char:detective
Да он ни имени, ни должности не назвал. # char:driver # anim:shrug
Бабушка как все бабушки. Блины, мол, жарит. Рассаду выращивает. # char:driver
В телефоне своем постоянно путает что-то. # char:driver
Людмила Игоревна Куликова. Раньше чиновница была. # response # char:detective
Куликова? # char:driver # anim:frown
Не помню такую. # char:driver
Ладно. А мальчик еще говорил что-то? # response # char:detective
Планы строил. Что с мамой летом на Майорку полетят. Мажор, что ли? # char:driver
Типа того. А как с автобуса сошел? # response # char:detective
Встречал его кто-нибудь? # response # char:detective
Нет. Пустая остановка была. # char:driver
И ты его отпустил так просто? # response # char:detective
А что я? У меня маршрут. # char:driver
Понятно. # response # char:detective
А что с мальком-то? # char:driver
Пропал. Ты последний его видел. # response # char:detective
Последний? Ё-маё… До бабки что ли не дошел? # char:driver # anim:shocked
Она не в Вязи тогда была. # response # char:detective
Узнаешь что-то — звони мне. # response # char:detective
А у тебя ловит? # char:driver # anim:downcast
Вообще-то нет. Думал, из-за бури. # response # char:detective
Тут только один оператор ловит нормально. Поищи симку, жить легче будет. # char:driver
~ knows_sim = true
Учту. # response # char:detective
Удачи в поисках. Найдётся пацан. Вязь маленькая, не заблудишься. # char:driver
Уж надеюсь. # response # char:detective
Начальник. А ты к Шнейдеру ходил уже? # char:driver # anim:wary
Он тут что ли до сих пор? # response # char:detective # anim:wince
А куда он денется? Без него тут ни один вопрос не решается. # char:driver
Вот поэтому у вас все и идёт через жопу. # response # char:detective
У тебя с ним проблемы какие-то? # char:driver
Мягко сказано. # response # char:detective
А ты все равно сходи. Если кто и поможет, то только он. # char:driver
Обойдусь. # response # char:detective
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
