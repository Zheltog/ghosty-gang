// Триггер: сам после отравленного чая или утреннего удара рукоятью.
# story: engineer_torture
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

-> wake

=== wake ===
Чувства возвращаются постепенно. Ты открываешь глаза и видишь перед собой инженера. # thought
-> ask

=== ask ===
Ты привязан к стулу в кладовке за шкафом. # thought
{gun_drawn:
	Очнулся? Вот и хорошо. Где твоё удостоверение? Документы? # window:default # char:engineer # anim:stand_shot
- else:
	Очнулся? Вот и хорошо. Где твоё удостоверение? Документы? # window:default # char:engineer # anim:stand_suspicious
}
Только паспорт. Я не из инстанций. # response
Бандит, значит? Киллер? # anim:sit_suspicious
Какой нахрен?.. # response
Кто тебя послал? Что тебе надо от меня? # window:default # char:engineer # anim:sit_suspicious
Слушай, мужик, я тут за мальчиком. До тебя мне вообще дела нет. # response
Ну конечно. # anim:sit_shocked
Ну конечно, ты же не думал, что после всего удастся просто потеряться. Интересно, кто прокололся. Игнатьев, скотина болтливая, наверняка он… # window:default # char:engineer # anim:stand_back
Мне всё-таки кажется, никакой ты не бандит. # window:default # char:engineer # anim:close_needle
Твои старшие коллеги из КГБ в своё время кое-чему меня научили. Кое-какие детали в протоколы вряд ли записали. # anim:close
Владислав, успокойся. Положи её. Я никакой не кэгэбэшник. Да я даже не мент уже. # response
Свежо предание. # anim:close_needle
Начнём. Первый вопрос: зачем тебя прислали сюда? Устранить меня? # window:default # char:engineer # anim:close_needle
Я ищу мальчика! # response
Последний шанс. # anim:close_needle
Да я правду говорю! # response
Он нажимает на иглу. # thought
-> after_stab

=== after_stab ===
Глаз ещё можно спасти, если остановиться сейчас. # window:default # char:engineer # anim:close_needle
Прекрати это! # response
Тогда отвечай на вопрос. Зачем ты тут? # anim:close
+ [Я ищу мальчика]
	Я же уже ответил. Я ищу мальчика. # response
	Не верю. Продолжаем. # window:default # char:engineer # anim:sit_shocked
	-> torture_2
+ [Я из органов. Мне нужны документы]
	Я из органов. Мне нужны только документы. Прекрати это! # response
	-> organs
+ [Меня послали убить тебя]
	Я из разведки. Меня послали убить тебя. # response
	Я так и думал. Что ж, тогда тянуть больше нет смысла. # window:default # char:engineer # anim:close
	Зря вы сюда приехали. # anim:close
	Не делай… # response
	-> END
+ [Встать и сбить его]
	-> shove

=== organs ===
Так-так. И что именно ты рассчитываешь тут найти? # window:default # char:engineer # anim:close
+ [Списки участников]
	Списки участников проекта. # response
	-> organs_known
+ [Чертежи установки]
	Чертежи установки. Той, что на фотографии. # response
	-> organs_known
+ [Доказательства опытов над людьми]
	Доказательства экспериментов над людьми. Нужно их уничтожить. # response
	-> organs_deal
+ [Контакты. Мы хотим добраться до Игнатьева]
	Контакты других членов проекта. Мы хотим добраться до Игнатьева. # response
	-> organs_deal

=== organs_known ===
У вас они и так есть. Дурить меня вздумал? Продолжаем. # window:default # char:engineer # anim:sit_suspicious
-> torture_2

=== organs_deal ===
Вот значит как… # window:default # char:engineer # anim:close
Инженер опускает иглу. # thought
Вы сможете гарантировать мою неприкосновенность, если я буду сотрудничать? # anim:close
Да. Слово офицера. # response
Мне надо подумать над этим. # anim:stand_back
-> chance

=== shove ===
Это лишнее. Не суетитесь. # window:default # char:engineer # anim:attack_chair
-> torture_2

=== torture_2 ===
Стой-стой-стой! # response
Снова давление и хруст. # thought
Вытащи её! # response
Ну-ну. # window:default # char:engineer # anim:close_needle
Сознание покидает тебя. Когда оно возвращается, тебя начинает рвать. # thought
Этого ещё не хватало. Омерзительно. Даже на брюки мои попал. Ну ничего. Где там тряпка? # window:default # char:engineer # anim:stand_suspicious
-> chance

=== chance ===
Он отворачивается к полке и начинает искать. # thought # char:engineer # anim:stand_back
Ты поднимаешься вместе со стулом и врезаешься в него лбом. # thought # char:engineer # anim:lay_shot
~ engineer_dead = true
Получай. # response
Ты снова теряешь сознание. Утром освобождаешься от верёвок и выбираешься из кладовки. # thought
Тут тебя никто не найдёт. # response
Жить буду. Но первым рейсом в больницу. # response
-> END
