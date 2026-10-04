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
	Очнулся? Вот и хорошо. Где твоё удостоверение? Документы? # window:default # char:engineer # anim:stand_shot # skippable:false
- else:
	Очнулся? Вот и хорошо. Где твоё удостоверение? Документы? # window:default # char:engineer # anim:stand_suspicious # skippable:false
}
Только паспорт. Я не из инстанций. # response # skippable:false
Бандит, значит? Киллер? # anim:sit_suspicious # skippable:false
Какой нахрен?.. # response # skippable:false
Кто тебя послал? Что тебе надо от меня? # window:default # char:engineer # anim:sit_suspicious # skippable:false
Слушай, мужик, я тут за мальчиком. До тебя мне вообще дела нет. # response # skippable:false
Ну конечно. # anim:sit_shocked # skippable:false
Ну конечно, ты же не думал, что после всего удастся просто потеряться. Интересно, кто прокололся. Игнатьев, скотина болтливая, наверняка он… # window:default # char:engineer # anim:stand_back # skippable:false
Мне всё-таки кажется, никакой ты не бандит. # window:default # char:engineer # anim:close_needle # skippable:false
Твои старшие коллеги из КГБ в своё время кое-чему меня научили. Кое-какие детали в протоколы вряд ли записали. # anim:close # skippable:false
Владислав, успокойся. Положи её. Я никакой не кэгэбэшник. Да я даже не мент уже. # response # skippable:false
Свежо предание. # anim:close_needle # skippable:false
Начнём. Первый вопрос: зачем тебя прислали сюда? Устранить меня? # window:default # char:engineer # anim:close_needle # skippable:false
Я ищу мальчика! # response # skippable:false
Последний шанс. # anim:close_needle # skippable:false
Да я правду говорю! # response # skippable:false
Он нажимает на иглу. # thought
-> after_stab

=== after_stab ===
Глаз ещё можно спасти, если остановиться сейчас. # window:default # char:engineer # anim:close_needle # skippable:false
Прекрати это! # response # skippable:false
Тогда отвечай на вопрос. Зачем ты тут? # anim:close # skippable:false
+ [Я ищу мальчика]
	Я же уже ответил. Я ищу мальчика. # response # skippable:false
	Не верю. Продолжаем. # window:default # char:engineer # anim:sit_shocked # skippable:false
	-> torture_2
+ [Я из органов. Мне нужны документы]
	Я из органов. Мне нужны только документы. Прекрати это! # response # skippable:false
	-> organs
+ [Меня послали убить тебя]
	Я из разведки. Меня послали убить тебя. # response # skippable:false
	Я так и думал. Что ж, тогда тянуть больше нет смысла. # window:default # char:engineer # anim:close # skippable:false
	Зря вы сюда приехали. # anim:close # skippable:false
	Не делай… # response # skippable:false
	-> END
+ [Встать и сбить его]
	-> shove

=== organs ===
Так-так. И что именно ты рассчитываешь тут найти? # window:default # char:engineer # anim:close # skippable:false
+ [Списки участников]
	Списки участников проекта. # response # skippable:false
	-> organs_known
+ [Чертежи установки]
	Чертежи установки. Той, что на фотографии. # response # skippable:false
	-> organs_known
+ [Доказательства опытов над людьми]
	Доказательства экспериментов над людьми. Нужно их уничтожить. # response # skippable:false
	-> organs_deal
+ [Контакты. Мы хотим добраться до Игнатьева]
	Контакты других членов проекта. Мы хотим добраться до Игнатьева. # response # skippable:false
	-> organs_deal

=== organs_known ===
У вас они и так есть. Дурить меня вздумал? Продолжаем. # window:default # char:engineer # anim:sit_suspicious # skippable:false
-> torture_2

=== organs_deal ===
Вот значит как… # window:default # char:engineer # anim:close # skippable:false
Инженер опускает иглу. # thought
Вы сможете гарантировать мою неприкосновенность, если я буду сотрудничать? # anim:close # skippable:false
Да. Слово офицера. # response # skippable:false
Мне надо подумать над этим. # anim:stand_back # skippable:false
-> chance

=== shove ===
Это лишнее. Не суетитесь. # window:default # char:engineer # anim:attack_chair # skippable:false
-> torture_2

=== torture_2 ===
Стой-стой-стой! # response # skippable:false
Снова давление и хруст. # thought
Вытащи её! # response # skippable:false
Ну-ну. # window:default # char:engineer # anim:close_needle # skippable:false
Сознание покидает тебя. Когда оно возвращается, тебя начинает рвать. # thought
Этого ещё не хватало. Омерзительно. Даже на брюки мои попал. Ну ничего. Где там тряпка? # window:default # char:engineer # anim:stand_suspicious # skippable:false
-> chance

=== chance ===
Он отворачивается к полке и начинает искать. # thought # char:engineer # anim:stand_back
Ты поднимаешься вместе со стулом и врезаешься в него лбом. # thought # char:engineer # anim:lay_shot
~ engineer_dead = true
Получай. # response # skippable:false
Ты снова теряешь сознание. Утром освобождаешься от верёвок и выбираешься из кладовки. # thought
Тут тебя никто не найдёт. # response # skippable:false
Жить буду. Но первым рейсом в больницу. # response # skippable:false
-> END
