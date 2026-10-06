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
Что вам ещё рассказать? # window:default # char:engineer # pose:sit # anim:normal # skippable:false
+ [О мальчике]
	Я в ПГТ не просто так. Пропал мальчик. # response # skippable:false
	-> boy_wait
* {has_glass_eye} [Вернуть стеклянный глаз]
	Это ваше? Под диваном нашёл. # response # skippable:false
	-> eye
+ [О лаборатории]
	На фотографии вы с коллегами? Из НИИ? # response # skippable:false
	-> lab
* {saw_passports} [equip:passport]
	-> passports
+ [equip:photo]
	-> boy
+ [equip:gun]
	-> gun
+ [На сегодня хватит]
	Что ж. Спасибо за чай. # response # skippable:false
	~ engineer_sleep = true
	-> END

=== boy_wait ===
Покажите. # window:default # char:engineer # pose:sit # anim:reach # skippable:false
+ [equip:photo]
	-> boy
+ [Позже]
	Позже. # response # skippable:false
	-> menu

=== boy ===
Неужели? # window:default # char:engineer # pose:sit # anim:shocked # skippable:false
Ты кладёшь перед ним фотографию Жени. # thought
Видел несколько раз. Летом всё бегал с местным пареньком на пустыре. Говорят, к бабушке приезжал. # window:default # char:engineer # anim:normal # skippable:false
А позавчера? # response # skippable:false
Да. Позавчера тоже видел. Из окна кухни. Он шёл от остановки в сторону Горной. # anim:normal # skippable:false
Во сколько? # response # skippable:false
В половине восьмого. Вечера, конечно. # anim:normal # skippable:false
-> boy_more

=== boy_more ===
Что именно? # window:default # char:engineer # pose:sit # anim:normal # skippable:false
* [Почему так точно?]
	Почему так точно? # response # skippable:false
	Вязал на кухне. Поглядывал на часы: пора было ужинать. В это время по нашей улице почти никто уже не ходит. # window:default # char:engineer # anim:normal # skippable:false
	Часы исправные? # response # skippable:false
	Да. Я же не перестаю быть инженером, когда выхожу на пенсию. # anim:normal # skippable:false
	-> boy_more
* [Во что он был одет?]
	Во что он был одет? # response # skippable:false
	Синяя куртка. Шапка белая с красным. Ещё рюкзак, как школьный. Больше ничего не заметил. # window:default # char:engineer # anim:normal # skippable:false
	-> boy_more
* [Он был один?]
	Он был один? # response # skippable:false
	Когда проходил мимо моего окна — один. Кто его встретил дальше, я не знаю. # window:default # char:engineer # anim:normal # skippable:false
	Вы не выходили? # response # skippable:false
	Нет. Я был дома. # anim:normal # skippable:false
	-> boy_more
+ [Дальше]
	-> menu
+ [equip:gun]
	-> gun

=== lab ===
Это имеет отношение к мальчику или вам просто интересно? # window:default # char:engineer # pose:sit # anim:suspicious # timeout:8 # skippable:false
+ [Промолчать]
	-> lab_short
+ [Если не хотите, оставим]
	Если не хотите, оставим. # response # skippable:false
	Спасибо. Очень любезно с вашей стороны. # window:default # char:engineer # anim:normal # skippable:false
	-> menu
+ [У вас столько книг. Я впечатлён]
	У вас столько книг. Я впечатлён. # response # skippable:false
	-> lab_story
+ [Всё может иметь отношение к делу]
	~ suspicion += 1
	Всё может иметь отношение к делу. # response # skippable:false
	-> lab_story

=== lab_short ===
Работал в лаборатории. Теперь на пенсии. Думаю, этого достаточно. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
-> menu

=== lab_story ===
Ну что ж. Мы работали у Бориса Николаевича Морозова. Вы, конечно, о нём слышали? # window:default # char:engineer # pose:sit # anim:normal # skippable:false
+ [Разумеется]
	~ suspicion += 1
	Разумеется. # response # skippable:false
	Да? Сейчас его редко вспоминают. # window:default # char:engineer # anim:suspicious # skippable:false
	-> lab_work
+ [Если честно, нет]
	Если честно, нет. # response # skippable:false
	В своё время его считали гением. Потом перестали. В науке это бывает быстрее, чем успевают убрать портреты со стен. # window:default # char:engineer # anim:normal # skippable:false
	-> lab_work

=== lab_work ===
Исследовали связь между некоторыми процессами в мозге и показаниями приборов. Я занимался аппаратурой. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
Получилось? # response # skippable:false
Не вполне. # anim:suspicious # skippable:false
Проект закрыли. Людей разослали. Аппаратуру разобрали. Вот и вся история. # anim:normal # skippable:false
-> lab_books

=== lab_books ===
* [Поэтому у вас книги по нейрофизиологии?]
	Поэтому у вас книги по нейрофизиологии? # response # skippable:false
	Разумеется. Когда прибор показывает что-то странное, хорошо бы знать, на что именно вы его направили. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> lab_books
* [А майя? Тоже для работы?]
	А майя? Тоже для работы? # response # skippable:false
	-> maya
+ [Вернёмся к мальчику]
	Понятно. Вернёмся к мальчику. # response # skippable:false
	-> menu

=== maya ===
{suspicion <= 1:
	Сначала личное. Потом оказалось, что и там можно найти кое-что полезное. # window:default # char:engineer # pose:sit # anim:reach # skippable:false
	Люди, с которыми работали наши физиологи, иногда описывали похожие вещи. Фигуры. Лица. Иногда умерших родственников. # window:default # char:engineer # anim:suspicious # skippable:false
	-> maya_more
}
Личное увлечение. В жизни должно быть что-нибудь, кроме работы. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
-> menu

=== maya_more ===
Какие вещи? # response # skippable:false
Можно сказать, галлюцинации. Я начал читать, как такие переживания описывали раньше. Сходство оказалось неприятным. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Неприятным? # response # skippable:false
У любого совпадения должен быть предел. # anim:normal # skippable:false
* [Когда это с ними происходило?]
	Когда это с ними происходило? # response # skippable:false
	Сильный стресс. Гипноз. Действие некоторых веществ. Переохлаждение тоже. # window:default # char:engineer # anim:suspicious # skippable:false
	-> maya_more
* [Вы верите в призраков?]
	Вы верите в призраков? # response # skippable:false
	Я предпочитаю сначала описать явление. Назвать всегда успеем. # window:default # char:engineer # anim:normal # skippable:false
	А объяснить? # response # skippable:false
	Вот с этим хуже. # anim:suspicious # skippable:false
	-> maya_more
+ [Сменим тему]
	Давайте сменим тему. # response # skippable:false
	Впрочем, оставим. Вам мальчика искать, а я вам голову забиваю. # window:default # char:engineer # anim:normal # skippable:false
	-> menu

=== passports ===
{not passports_raised:
	~ passports_raised = true
	~ suspicion += 3
}
В вашей кладовке несколько паспортов. С вашей фотографией. На разные имена. # response # skippable:false
Вижу, вы всё-таки успели покопаться в моих вещах. # window:default # char:engineer # pose:sit # anim:shocked # skippable:false
Я могу услышать объяснение? # response # skippable:false
Несколько выданы партией. Конспиративные, если угодно. Но государственные. # anim:suspicious # skippable:false
Это как? # response # skippable:false
Когда проект закрыли, нас попросили сменить имена. Работу, место жительства. Научная история закончилась, секретность осталась. # anim:normal # skippable:false
А остальные? # response # skippable:false
Поддельные. Партийный паспорт только вредит, если зачищать хвосты взялась сама партия. # anim:suspicious # skippable:false
Но зачем столько? # response # skippable:false
Ответ очевиден: потому что менять их приходилось не раз и не два. # anim:normal # skippable:false
Вы параноик. # response # skippable:false
Неужели? Я жив. Мои коллеги нет. # anim:suspicious # skippable:false
-> passport_more

=== passport_more ===
* [Кто вы на самом деле?]
	Кто вы на самом деле? # response # skippable:false
	Владислав Игоревич Хаит. Так меня зовут здесь. Так я вам представился. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	А раньше? # response # skippable:false
	Я уже рассказал больше, чем собирался. Пожалуйста. # anim:suspicious # skippable:false
	-> passport_more
* [Вы сюда переехали после лаборатории?]
	Вы сюда переехали после закрытия лаборатории? # response # skippable:false
	Да. Мне дали адрес и документы. Я приехал. Другого места у меня теперь нет. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> passport_more
+ [Меня интересует мальчик]
	Я ищу мальчика. Ваше прошлое меня не интересует. # response # skippable:false
	Тогда давайте о мальчике. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> menu

=== eye ===
Ты кладёшь глаз на стол. # thought
Моё. Давно искал. Спасибо. # window:default # char:engineer # pose:sit # anim:reach # skippable:false
Запасной? # response # skippable:false
Старый. Новый мне тоже не вполне нравится. # anim:suspicious # skippable:false
Он убирает глаз в карман. # thought # char:engineer # pose:stand # anim:back
~ has_glass_eye = false
-> menu

INCLUDE _engineer_gun_reaction_include.ink
