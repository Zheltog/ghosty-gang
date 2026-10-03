// Триггер: сам после чая, если не отравил, не выгнал и не убит.
// О мальчике — equip:photo. Паспорта — equip:passport. Ствол — equip:gun.
# story: engineer_interview
# load: suspicion, closet_open, key_returned, saw_passports, has_glass_eye, gun_drawn, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, engineer_to_torture, engineer_leave, passports_raised
# save: suspicion, closet_open, key_returned, saw_passports, has_glass_eye, gun_drawn, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, engineer_to_torture, engineer_leave, passports_raised

VAR suspicion = 0
VAR closet_open = false
VAR key_returned = false
VAR saw_passports = false
VAR has_glass_eye = false
VAR gun_drawn = false
VAR engineer_dead = false
VAR engineer_poison = false
VAR engineer_kicked = false
VAR engineer_sleep = false
VAR engineer_to_torture = false
VAR engineer_leave = false
VAR passports_raised = false

-> menu

=== menu ===
Что вам ещё рассказать? # window:default # char:engineer # anim:sit_normal
+ [О мальчике]
	Я в ПГТ не просто так. Пропал мальчик. # response
	-> boy_wait
* {has_glass_eye} [Вернуть стеклянный глаз]
	Это ваше? Под диваном нашёл. # response
	-> eye
+ [О лаборатории]
	На фотографии вы с коллегами? Из НИИ? # response
	-> lab
* {saw_passports} [equip:passport]
	-> passports
+ [equip:photo]
	-> boy
+ [equip:gun]
	-> gun
+ [На сегодня хватит]
	Что ж. Спасибо за чай. # response
	~ engineer_sleep = true
	-> END

=== boy_wait ===
Покажите. # window:default # char:engineer # anim:sit_reach
+ [equip:photo]
	-> boy
+ [Позже]
	Позже. # response
	-> menu

=== boy ===
Неужели? # window:default # char:engineer # anim:sit_shocked
Ты кладёшь перед ним фотографию Жени. # thought
Видел несколько раз. Летом всё бегал с местным пареньком на пустыре. Говорят, к бабушке приезжал. # window:default # char:engineer # anim:sit_normal
А позавчера? # response
Да. Позавчера тоже видел. Из окна кухни. Он шёл от остановки в сторону Горной. # anim:sit_normal
Во сколько? # response
В половине восьмого. Вечера, конечно. # anim:sit_normal
-> boy_more

=== boy_more ===
Что именно? # window:default # char:engineer # anim:sit_normal
* [Почему так точно?]
	Почему так точно? # response
	Вязал на кухне. Поглядывал на часы: пора было ужинать. В это время по нашей улице почти никто уже не ходит. # window:default # char:engineer # anim:sit_normal
	Часы исправные? # response
	Да. Я же не перестаю быть инженером, когда выхожу на пенсию. # anim:sit_normal
	-> boy_more
* [Во что он был одет?]
	Во что он был одет? # response
	Синяя куртка. Шапка белая с красным. Ещё рюкзак, как школьный. Больше ничего не заметил. # window:default # char:engineer # anim:sit_normal
	-> boy_more
* [Он был один?]
	Он был один? # response
	Когда проходил мимо моего окна — один. Кто его встретил дальше, я не знаю. # window:default # char:engineer # anim:sit_normal
	Вы не выходили? # response
	Нет. Я был дома. # anim:sit_normal
	-> boy_more
+ [Дальше]
	-> menu
+ [equip:gun]
	-> gun

=== lab ===
Это имеет отношение к мальчику или вам просто интересно? # window:default # char:engineer # anim:sit_suspicious # timeout:8
+ [Промолчать]
	-> lab_short
+ [Если не хотите, оставим]
	Если не хотите, оставим. # response
	Спасибо. Очень любезно с вашей стороны. # window:default # char:engineer # anim:sit_normal
	-> menu
+ [У вас столько книг. Я впечатлён]
	У вас столько книг. Я впечатлён. # response
	-> lab_story
+ [Всё может иметь отношение к делу]
	~ suspicion += 1
	Всё может иметь отношение к делу. # response
	-> lab_story

=== lab_short ===
Работал в лаборатории. Теперь на пенсии. Думаю, этого достаточно. # window:default # char:engineer # anim:sit_normal
-> menu

=== lab_story ===
Ну что ж. Мы работали у Бориса Николаевича Морозова. Вы, конечно, о нём слышали? # window:default # char:engineer # anim:sit_normal
+ [Разумеется]
	~ suspicion += 1
	Разумеется. # response
	Да? Сейчас его редко вспоминают. # window:default # char:engineer # anim:sit_suspicious
	-> lab_work
+ [Если честно, нет]
	Если честно, нет. # response
	В своё время его считали гением. Потом перестали. В науке это бывает быстрее, чем успевают убрать портреты со стен. # window:default # char:engineer # anim:sit_normal
	-> lab_work

=== lab_work ===
Исследовали связь между некоторыми процессами в мозге и показаниями приборов. Я занимался аппаратурой. # window:default # char:engineer # anim:sit_normal
Получилось? # response
Не вполне. # anim:sit_suspicious
Проект закрыли. Людей разослали. Аппаратуру разобрали. Вот и вся история. # anim:sit_normal
-> lab_books

=== lab_books ===
* [Поэтому у вас книги по нейрофизиологии?]
	Поэтому у вас книги по нейрофизиологии? # response
	Разумеется. Когда прибор показывает что-то странное, хорошо бы знать, на что именно вы его направили. # window:default # char:engineer # anim:sit_normal
	-> lab_books
* [А майя? Тоже для работы?]
	А майя? Тоже для работы? # response
	-> maya
+ [Вернёмся к мальчику]
	Понятно. Вернёмся к мальчику. # response
	-> menu

=== maya ===
{suspicion <= 1:
	Сначала личное. Потом оказалось, что и там можно найти кое-что полезное. # window:default # char:engineer # anim:sit_reach
	Люди, с которыми работали наши физиологи, иногда описывали похожие вещи. Фигуры. Лица. Иногда умерших родственников. # window:default # char:engineer # anim:sit_suspicious
	-> maya_more
}
Личное увлечение. В жизни должно быть что-нибудь, кроме работы. # window:default # char:engineer # anim:sit_normal
-> menu

=== maya_more ===
Какие вещи? # response
Можно сказать, галлюцинации. Я начал читать, как такие переживания описывали раньше. Сходство оказалось неприятным. # window:default # char:engineer # anim:sit_suspicious
Неприятным? # response
У любого совпадения должен быть предел. # anim:sit_normal
* [Когда это с ними происходило?]
	Когда это с ними происходило? # response
	Сильный стресс. Гипноз. Действие некоторых веществ. Переохлаждение тоже. # window:default # char:engineer # anim:sit_suspicious
	-> maya_more
* [Вы верите в призраков?]
	Вы верите в призраков? # response
	Я предпочитаю сначала описать явление. Назвать всегда успеем. # window:default # char:engineer # anim:sit_normal
	А объяснить? # response
	Вот с этим хуже. # anim:sit_suspicious
	-> maya_more
+ [Сменим тему]
	Давайте сменим тему. # response
	Впрочем, оставим. Вам мальчика искать, а я вам голову забиваю. # window:default # char:engineer # anim:sit_normal
	-> menu

=== passports ===
{not passports_raised:
	~ passports_raised = true
	~ suspicion += 3
}
В вашей кладовке несколько паспортов. С вашей фотографией. На разные имена. # response
Вижу, вы всё-таки успели покопаться в моих вещах. # window:default # char:engineer # anim:sit_shocked
Я могу услышать объяснение? # response
Несколько выданы партией. Конспиративные, если угодно. Но государственные. # anim:sit_suspicious
Это как? # response
Когда проект закрыли, нас попросили сменить имена. Работу, место жительства. Научная история закончилась, секретность осталась. # anim:sit_normal
А остальные? # response
Поддельные. Партийный паспорт только вредит, если зачищать хвосты взялась сама партия. # anim:sit_suspicious
Но зачем столько? # response
Ответ очевиден: потому что менять их приходилось не раз и не два. # anim:sit_normal
Вы параноик. # response
Неужели? Я жив. Мои коллеги нет. # anim:sit_suspicious
-> passport_more

=== passport_more ===
* [Кто вы на самом деле?]
	Кто вы на самом деле? # response
	Владислав Игоревич Хаит. Так меня зовут здесь. Так я вам представился. # window:default # char:engineer # anim:sit_normal
	А раньше? # response
	Я уже рассказал больше, чем собирался. Пожалуйста. # anim:sit_suspicious
	-> passport_more
* [Вы сюда переехали после лаборатории?]
	Вы сюда переехали после закрытия лаборатории? # response
	Да. Мне дали адрес и документы. Я приехал. Другого места у меня теперь нет. # window:default # char:engineer # anim:sit_normal
	-> passport_more
+ [Меня интересует мальчик]
	Я ищу мальчика. Ваше прошлое меня не интересует. # response
	Тогда давайте о мальчике. # window:default # char:engineer # anim:sit_normal
	-> menu

=== eye ===
Ты кладёшь глаз на стол. # thought
Моё. Давно искал. Спасибо. # window:default # char:engineer # anim:sit_reach
Запасной? # response
Старый. Новый мне тоже не вполне нравится. # anim:sit_suspicious
Он убирает глаз в карман. # thought # char:engineer # anim:stand_back
~ has_glass_eye = false
-> menu

=== gun ===
{not gun_drawn:
	~ gun_drawn = true
	~ suspicion += 5
}
Что вы делаете? Уберите его! # window:default # char:engineer # anim:stand_scared
+ [unequip:gun]
	~ gun_drawn = false
	Прошу вас, не делайте так больше. # window:default # char:engineer # anim:stand_default
	-> menu
+ [action:shoot]
	Выстрел. # thought # char:engineer # anim:sit_shot
	# char:engineer # anim:lay_shot
	~ engineer_dead = true
	-> END
