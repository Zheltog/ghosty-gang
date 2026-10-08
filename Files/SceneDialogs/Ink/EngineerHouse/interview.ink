// После тряпки: вытереть лужу, чай, опрос.
// Если за тряпкой не ходили — спокойный чай и тот же опрос.
// Выпитый после лужи чай отравлен.
EXTERNAL godot_1(target_class, method, arg)
# story: engineer_interview
# load: suspicion, saw_passports, has_glass_eye, gun_drawn, saw_gun, explained_gun, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, passports_raised, fetching_rag
# save: suspicion, saw_passports, has_glass_eye, gun_drawn, saw_gun, explained_gun, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, passports_raised, fetching_rag

VAR suspicion = 0
VAR saw_passports = false
VAR has_glass_eye = false
VAR gun_drawn = false
VAR saw_gun = false
VAR explained_gun = false
VAR engineer_dead = false
VAR engineer_poison = false
VAR engineer_kicked = false
VAR engineer_sleep = false
VAR passports_raised = false
VAR fetching_rag = false
VAR menu_started = false
VAR boy_told = false

INCLUDE gun_reaction.ink

-> begin

=== begin ===
# react_default:equip:rag:show_rag_given, equip:gun:gun_show_rag
{gun_drawn:
	-> armed
}
{fetching_rag:
	-> show_rag
}
-> calm

=== armed ===
-> gun ->
{fetching_rag:
	-> show_rag
}
-> calm

=== show_rag ===
Чай уже налит. Владислав с блаженным видом отхлебывает из своей кружки. # thought # char:engineer # pose:sit # anim:normal
+ [Показать тряпку.]
	-> show_rag_given

=== wiped ===
# react_default:equip:rag:show_rag_given, equip:gun:gun:back
~ godot_1("SceneDialogManager", "process_event", "reveal_tea")
Ты вытираешь лужу со столика и садишься рядом. Крепкий чёрный чай пахнет восхитительно — старик добавил сушеные листья смородины и мяты. # thought
Пейте. Вам сейчас согреться надо. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
+ [Пусть сперва остынет.]
	Пусть сперва остынет. # response # skippable:false
	Хозяин пожимает плечами. # thought # char:engineer # pose:sit # anim:normal
	-> menu
+ [Не буду я ваш чай пить.]
	Не буду я ваш чай пить. Вдруг вы подмешали мне что-то? # response # skippable:false
	-> refuse

=== poison ===
Чай крепкий и немного горчит. Ты ставишь чашку на стол. # thought
А насчёт мальчика… # response # skippable:false
Слова вдруг приходится выталкивать. Ты пытаешься поднять руку. Пальцы остаются на месте. # thought
Владислав перестаёт улыбаться. # thought # char:engineer # pose:sit # anim:suspicious
Что… # response # skippable:false
Не пытайтесь встать. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Ты чувствуешь, как съезжаешь по спинке дивана. # thought
Слышите меня? # window:default # char:engineer # pose:sit # anim:reach # skippable:false
Ты видишь его губы, но ответить не получается. # thought
~ engineer_poison = true
-> END

=== refuse ===
Вы меня за кого принимаете? # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Я сказал, что не хочу. # response # skippable:false
Понял. И к вещам моим это тоже отношения не имеет? # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Он ставит собственную чашку на стол. # thought
Извините. Не получится у нас сегодня с ночлегом. # window:default # char:engineer # pose:stand # anim:normal # skippable:false
~ engineer_kicked = true
-> END

=== calm ===
# react_default: equip:gun:gun:back
Инженер берёт чайник и не спеша разливает его по чашкам. Он улыбается и мурлычет себе под нос. # thought # char:engineer # pose:stand # anim:tea
Тонут во мгле пустынные сопки, # window:default # char:engineer # pose:stand # anim:tea # skippable:false
тучей закрыт восток… # char:engineer # pose:stand # anim:tea # skippable:false
Великолепный запах крепкого чая с травами разливается по комнате. # thought
Со смородиной? То, что доктор прописал. # response # skippable:false
И с мятой. Мон плезир. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
-> cup

=== cup ===
~ godot_1("SceneDialogManager", "process_event", "reveal_tea")
Он пододвигает к тебе чашку. # thought # char:engineer # pose:sit # anim:reach # react:action:drink:cup_drink, equip:gun:gun_cup # react_wait
-> DONE

=== menu ===
{not menu_started:
	~ menu_started = true
	Итак. О чём вы хотели поговорить? # window:default # char:engineer # pose:sit # anim:normal # skippable:false # react:equip:photo:photo_if, equip:passport:passports_if, equip:glass_eye:eye_if, equip:gun:gun_menu
- else:
	Что вам ещё рассказать? # window:default # char:engineer # pose:sit # anim:normal # skippable:false # react:equip:photo:photo_if, equip:passport:passports_if, equip:glass_eye:eye_if, equip:gun:gun_menu
}
* [О мальчике.]
	-> boy_ask
* [О лаборатории.]
	На фотографии вы с коллегами? Из НИИ? # response # skippable:false
	-> lab
* {saw_passports} [О паспортах.]
	-> passports
+ [На сегодня хватит.]
	Что ж. Спасибо за чай. # response # skippable:false
	~ engineer_sleep = true
	-> END

=== boy_ask ===
Я в ПГТ не просто так, как вы могли догадаться. Пропал мальчик. # response # skippable:false
Неужели? # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Покажите. # char:engineer # pose:sit # anim:reach # skippable:false
+ [Протянуть фото]
	-> boy_photo
+ [Позже.]
	Позже. # response # skippable:false
	-> menu

=== boy_shown ===
Я в ПГТ не просто так, как вы могли догадаться. Пропал мальчик. # response # skippable:false
Неужели? # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
-> boy_photo

=== boy_photo ===
~ boy_told = true
Ты кладёшь перед Владиславом фотографию Жени. Он придвигает её к свету. # thought # char:engineer # pose:sit # anim:reach
Видел несколько раз. Летом всё бегал с местным пареньком на пустыре. Говорят, к бабушке приезжал. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
А позавчера? # response # skippable:false
Да. Позавчера тоже видел. Из окна кухни. Он шёл от остановки в сторону Горной. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
Во сколько? # response # skippable:false
В половине восьмого. Вечера, конечно. # char:engineer # pose:sit # anim:normal # skippable:false
-> boy_more

=== boy_more ===
* [Почему так точно?]
	Почему так точно? # response # skippable:false
	Вязал на кухне. Поглядывал на часы: пора было ужинать. Потом увидел его в окне. В это время по нашей улице почти никто уже не ходит. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	Часы исправные? # response # skippable:false
	Да. Я же не перестаю быть инженером, когда выхожу на пенсию. # char:engineer # pose:sit # anim:normal # skippable:false
	-> boy_more
* [Во что он был одет?]
	Во что он был одет? # response # skippable:false
	Синяя куртка. Шапка белая с красным. Ещё рюкзак — как школьный. Больше ничего не заметил. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	Пока всё сходится. # thought
	-> boy_more
* [Он был один?]
	Он был один? # response # skippable:false
	Когда проходил мимо моего окна — один. Кто его встретил дальше, я не знаю. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	Вы не выходили? # response # skippable:false
	Нет. Я был дома. # char:engineer # pose:sit # anim:normal # skippable:false
	-> boy_more
+ [Дальше.]
	-> menu

=== lab ===
Это имеет отношение к мальчику или вам просто интересно? # window:default # char:engineer # pose:sit # anim:suspicious # timeout:8 # skippable:false
+ [Промолчать.]
	-> lab_short
+ [Если не хотите, оставим.]
	Если не хотите, оставим. # response # skippable:false
	Спасибо. Очень любезно с вашей стороны. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> menu
+ [У вас столько книг. Я впечатлён.]
	У вас столько книг. Я впечатлён. # response # skippable:false
	-> lab_story
+ [Всё может иметь отношение к делу.]
	~ suspicion += 1
	Всё может иметь отношение к делу. # response # skippable:false
	-> lab_story

=== lab_short ===
Работал в лаборатории. Теперь на пенсии. Думаю, этого достаточно. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
-> menu

=== lab_story ===
Ну что ж. Мы работали у Бориса Николаевича Морозова. Вы, конечно, о нём слышали? # window:default # char:engineer # pose:sit # anim:normal # skippable:false
+ [Разумеется.]
	~ suspicion += 1
	Разумеется. # response # skippable:false
	Да? Сейчас его редко вспоминают. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
	Он смотрит внимательнее, словно ждёт, что ты продолжишь. # window:thought # skippable:false
	-> lab_work
+ [Если честно, нет.]
	Если честно, нет. # response # skippable:false
	В своё время его считали гением. Потом перестали. В науке это, знаете, бывает быстрее, чем успевают убрать портреты со стен. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> lab_work

=== lab_work ===
Исследовали связь между некоторыми процессами в мозге и показаниями приборов. Я занимался аппаратурой. Были физиологи, были физики. Должны были научиться понимать друг друга. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
Получилось? # response # skippable:false
Не вполне. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Владислав смотрит на фотографию. # thought # char:engineer # pose:sit # anim:normal
Проект закрыли. Людей разослали. Аппаратуру разобрали. Вот и вся история. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
-> lab_books

=== lab_books ===
* [Поэтому у вас книги по нейрофизиологии?]
	Поэтому у вас книги по нейрофизиологии? # response # skippable:false
	Разумеется. Когда прибор показывает что-то странное, хорошо бы знать, на что именно вы его направили. Хоть немного. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> lab_books
* [А майя? Тоже для работы?]
	А майя? Тоже для работы? # response # skippable:false
	-> maya
+ [Понятно. Вернёмся к мальчику.]
	Понятно. Вернёмся к мальчику. # response # skippable:false
	-> menu

=== maya ===
{suspicion <= 1:
	-> maya_long
}
Личное увлечение. В жизни должно быть что-нибудь, кроме работы. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
-> menu

=== maya_long ===
Сначала личное. Потом оказалось, что и там можно найти кое-что полезное. # window:default # char:engineer # pose:sit # anim:reach # skippable:false
Он проводит пальцем по краю стола. # thought # char:engineer # pose:sit # anim:reach
Люди, с которыми работали наши физиологи, иногда описывали похожие вещи. Очень похожие. Хотя друг друга не знали. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Какие вещи? # response # skippable:false
Фигуры. Лица. Иногда умерших родственников. Можно сказать — галлюцинации. Я начал читать, как такие переживания описывали раньше. Сходство оказалось неприятным. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Неприятным? # response # skippable:false
У любого совпадения должен быть предел. # char:engineer # pose:sit # anim:normal # skippable:false
* [Когда это с ними происходило?]
	Когда это с ними происходило? # response # skippable:false
	Сильный стресс. Гипноз. Действие некоторых веществ. Переохлаждение тоже. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
	На последнем слове он смотрит на твои руки. # thought # char:engineer # pose:sit # anim:suspicious
	-> maya_close
* [Вы верите в призраков?]
	Вы верите в призраков? # response # skippable:false
	Я предпочитаю сначала описать явление. Назвать всегда успеем. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	А объяснить? # response # skippable:false
	Вот с этим хуже. # char:engineer # pose:sit # anim:suspicious # skippable:false
	-> maya_close
+ [Давайте сменим тему.]
	Давайте сменим тему. # response # skippable:false
	-> maya_close

=== maya_close ===
Впрочем, оставим. Вам мальчика искать, а я вам голову забиваю. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
-> menu

=== passports ===
{passports_raised:
	-> passport_more
}
~ passports_raised = true
~ suspicion += 3
В вашей кладовке несколько паспортов. С вашей фотографией. На разные имена. # response # skippable:false
Владислав перестаёт поправлять салфетку. # thought # char:engineer # pose:sit # anim:scared
Вижу, вы всё-таки успели покопаться в моих вещах. # window:default # char:engineer # pose:sit # anim:scared # skippable:false
Я могу услышать объяснение? # response # skippable:false
Несколько выданы партией. Конспиративные, если угодно. Но государственные. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Это как? # response # skippable:false
Когда проект закрыли, нас попросили сменить имена. Работу, место жительства. Научная история закончилась, секретность осталась. # char:engineer # pose:sit # anim:normal # skippable:false
А остальные? # response # skippable:false
Поддельные. Партийный паспорт только вредит, если зачищать хвосты взялась сама партия. # char:engineer # pose:sit # anim:suspicious # skippable:false
Но зачем столько? # response # skippable:false
Ответ очевиден: потому что менять их приходилось не раз и не два. # char:engineer # pose:sit # anim:normal # skippable:false
Вы параноик. # response # skippable:false
Неужели? Я жив. Мои коллеги нет. # char:engineer # pose:sit # anim:suspicious # skippable:false
Он замолкает. # thought # char:engineer # pose:sit # anim:suspicious
-> passport_more

=== passport_more ===
* [Кто вы на самом деле?]
	Кто вы на самом деле? # response # skippable:false
	Владислав Игоревич Хаит. Так меня зовут здесь. Так я вам представился. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	А раньше? # response # skippable:false
	Я уже рассказал больше, чем собирался. Пожалуйста. # char:engineer # pose:sit # anim:suspicious # skippable:false
	-> passport_more
* [Вы сюда переехали после закрытия лаборатории?]
	Вы сюда переехали после закрытия лаборатории? # response # skippable:false
	Да. Мне дали адрес и документы. Я приехал. Другого места у меня теперь нет. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> passport_more
+ [Я ищу мальчика. Ваше прошлое меня не интересует.]
	Я ищу мальчика. Ваше прошлое меня не интересует. # response # skippable:false
	Владислав медленно кивает. # thought # char:engineer # pose:sit # anim:normal
	Тогда давайте о мальчике. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> menu

=== eye ===
# char:engineer # pose:sit # anim:reach
~ godot_1("Inventory", "remove_item_str", "glass_eye")
~ godot_1("SceneDialogManager", "process_event", "reveal_glass_eye")
Ты кладёшь глаз на стол. Владислав забирает его раньше, чем тот успевает докатиться до чашки. # thought
~ godot_1("SceneDialogManager", "process_event", "hide_glass_eye")
Моё. Давно искал. Спасибо. # window:default # char:engineer # pose:sit # anim:reach # skippable:false
Запасной? # response # skippable:false
Старый. Новый мне тоже не вполне нравится. # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Он убирает глаз в карман. Тебе хочется рассмотреть его лицо внимательнее, но он уже отвернулся. # thought
~ has_glass_eye = false
-> menu

=== show_rag_given ===
Ты достаёшь тряпку из инвентаря и показываешь её инженеру. # thought
~ fetching_rag = false
~ godot_1("Inventory", "remove_item_str", "rag")
-> wiped

=== cup_drink ===
Ты делаешь глоток. Просто прекрасно. # thought
-> menu

=== photo_if ===
{boy_told:
	# react_default:equip:gun:gun_boy_more
	-> boy_more
}
-> boy_shown

=== passports_if ===
{saw_passports:
	-> passports
}
-> menu

=== eye_if ===
Это ваше? Под диваном нашёл. # response # skippable:false
	-> eye
-> menu

=== gun_show_rag ===
-> gun ->
-> show_rag

=== gun_wiped ===
-> gun ->
-> wiped

=== gun_cup ===
-> gun ->
-> cup

=== gun_menu ===
-> gun ->
-> menu

=== gun_boy_more ===
-> gun ->
# react_default:equip:gun:gun_boy_more
-> boy_more

=== gun_lab_books ===
-> gun ->
# react_default:equip:gun:gun_lab_books
-> lab_books

=== gun_passport_more ===
-> gun ->
# react_default:equip:gun:gun_passport_more
-> passport_more
