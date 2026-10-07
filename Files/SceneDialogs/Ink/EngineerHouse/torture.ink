// Пытка в кладовке. Вход один: отравленный чай, удар во сне и оглушение после выстрела сюда не ветвятся.
EXTERNAL godot_2(target_class, method, arg0, arg1)
# story: torture
# load: engineer_dead
# save: engineer_dead

VAR engineer_dead = false

-> wake

=== wake ===
# skip_default:false
Чувства возвращаются постепенно. Сначала головная боль. Затем — жжение в кистях рук. Звон в ушах. Наконец, ты с усилием открываешь заплывшие глаза и видишь свои ноги. Что ж, по крайней мере они не связаны. # window:thought
Ты поднимаешь голову и видишь перед собой фигуру инженера. # window:thought
Ты привязан к стулу в кладовке за шкафом. Руки связаны накрепко, так что ты не чувствуешь пальцев. # window:thought
Очнулся? Вот и хорошо. Где твоё удостоверение? Документы? # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Только паспорт. Я не из инстанций. # response # skippable:false
Бандит, значит? Киллер? # char:engineer # pose:stand # anim:suspicious # skippable:false
Какой нахрен?.. # response # skippable:false
Кто тебя послал? Что тебе надо от меня? # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Слушай, мужик, я тут за мальчиком. До тебя мне вообще дела нет. # response # skippable:false
Ну конечно. # char:engineer # pose:stand # anim:suspicious # skippable:false
~ godot_2("HouseScenePreview", "set_character_emotion", "engineer", "stand_back")
Инженер отворачивается. Ты не видишь, что он делает, но предчувствие у тебя плохое. # window:thought
Ну конечно, ты же не думал, что после всего удастся просто потеряться? Интересно, кто всё-таки прокололся? Игнатьев, скотина болтливая, наверняка он… # window:default # char:engineer # pose:stand # anim:back # skippable:false
~ godot_2("HouseScenePreview", "set_character_emotion", "engineer", "stand_suspicious")
Он оборачивается. В руках вязальная спица и зажигалка. # window:thought
Мне всё-таки кажется, никакой ты не бандит. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Твои старшие коллеги из КГБ в своё время кое-чему меня научили. После первой облавы, когда брали Морозова. Ты, наверное, и сам читал материалы допросов. # char:engineer # pose:stand # anim:suspicious # skippable:false
Но кое-какие детали туда вряд ли записали. # char:engineer # pose:stand # anim:suspicious # skippable:false
Спица в его руке зловеще сверкнула. # window:thought
Владислав, успокойся. Положи её. Я никакой не кэгэбэшник. Да я даже не мент уже! # response # skippable:false
Свежо предание. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Он подносит спицу к твоему глазу. Ты рефлекторно сжимаешь веки, но он открывает их пальцами. # window:thought
Начнём. Первый вопрос: зачем тебя прислали сюда? Устранить меня? # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Я ищу мальчика! # response # skippable:false
Владислав цокает и упирает иглу в твоё глазное яблоко. Ты чувствуешь металлическое прикосновение. Пульс зашкаливает. # window:thought
Последний шанс. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Да я правду говорю! # response # skippable:false
Инженер вздыхает и нажимает на иглу. Ты чувствуешь давление в глазу, затем хруст. Красная вспышка боли застилает весь мир. # window:thought
ААААААААА! СУКА! # response # skippable:false
-> after_stab

=== after_stab ===
Глаз ещё можно спасти, если остановиться сейчас. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
ПРЕКРАТИ ЭТО! # response # skippable:false
Тогда отвечай на вопрос. Зачем ты тут? # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false # timeout:4
+ [Я ищу мальчика.]
	Я же уже ответил. Я ищу мальчика. # response # skippable:false
	Не верю. Продолжаем. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
	-> torture_2
+ [Мне нужны только документы.]
	Я из органов. Мне нужны только документы. Прекрати это! # response # skippable:false
	-> organs
+ [Меня послали убить тебя.]
	Я из разведки. Меня послали убить тебя. # response # skippable:false
	Я так и думал. Что ж, тогда тянуть больше нет смысла. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
	~ godot_2("HouseScenePreview", "set_character_emotion", "engineer", "stand_normal")
	Он достаёт пистолет и направляет его прямо в твою голову. # window:thought
	Зря вы сюда приехали. # window:default # char:engineer # pose:stand # anim:normal # skippable:false
	Не делай… # response # skippable:false
	Ты даже не успеваешь услышать выстрел — просто смотришь, будто в замедленной съёмке, как его палец вжимает курок. # window:thought
	Все кончено. # window:thought
	-> END
+ [<Попытаться встать со стула>]
	-> shove

=== organs ===
Так-так. И что именно ты рассчитываешь тут найти? # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false # timeout:6
+ [Списки участников проекта.]
	Списки участников проекта. # response # skippable:false
	-> organs_known
+ [Чертежи установки.]
	Чертежи установки. Той, что на фотографии. # response # skippable:false
	-> organs_known
+ [Доказательства экспериментов над людьми. Нужно их уничтожить.]
	Доказательства экспериментов над людьми. Нужно их уничтожить. # response # skippable:false
	-> organs_deal
+ [Контакты других членов проекта. Мы хотим добраться до Игнатьева.]
	Контакты других членов проекта. Мы хотим добраться до Игнатьева. # response # skippable:false
	-> organs_deal

=== organs_known ===
У вас они и так есть. Дурить меня вздумал? Продолжаем. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
-> torture_2

=== organs_deal ===
Вот значит как… # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
~ godot_2("HouseScenePreview", "set_character_emotion", "engineer", "stand_normal")
Инженер опускает иглу. Видно, что он колеблется. # window:thought
Вы сможете гарантировать мою неприкосновенность, если я буду сотрудничать? # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Да. Слово офицера. # response # skippable:false
Мне надо подумать над этим. # window:default # char:engineer # pose:stand # anim:back # skippable:false
-> chance

=== shove ===
Инженер успевает понять, что ты пытаешься сделать, и с силой усаживает тебя обратно. # window:thought # char:engineer
Это лишнее. Не суетитесь. # window:default # char:engineer # pose:stand # anim:chair # skippable:false
-> torture_2

=== torture_2 ===
Стой-стой-стой! # response # skippable:false
Снова давление и хруст. Господи, почему хруст такой громкий? Невыносимая боль пронизывает тебя. # window:thought
ВЫТАЩИ ЕЁ! # response # skippable:false
Ну-ну. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Сознание покидает тебя. # window:thought
Через время ты начинаешь приходить в себя. Боль сузилась до размеров глазницы. Злая, пульсирующая, она перемешивает твои мысли. # window:thought
Ты чувствуешь, как что-то капает на колени. Ты стараешься не всматриваться, чтобы не стошнило. Сдержать позыв не получается, и тебя начинает рвать. # window:thought
Этого ещё не хватало! Омерзительно. Даже на брюки мои попал, гад. Ну, ничего. Где там тряпка? # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
-> chance

=== chance ===
~ godot_2("HouseScenePreview", "set_character_emotion", "engineer", "stand_back")
Он отворачивается к полке и начинает искать что-то. # window:thought
Вот он. Твой шанс. # window:thought
Ты с усилием поднимаешься вместе со стулом и врезаешься в инженера. Ты вложил все силы в удар лбом по его затылку. # window:thought
~ godot_2("HouseScenePreview", "set_character_emotion", "engineer", "lay_dead")
Раздаётся хруст, и Владислав опускается на пол ничком. Под его лицом растекается кровь. # window:thought
Тебе повезло: удар впечатал инженера лицом в крепёж на стене, который вогнал кость в его мозг. Он мёртв — это точно. # window:thought
Получай, с-сука… # response # skippable:false
Ты валишься на пол и снова теряешь сознание. # window:thought
~ engineer_dead = true
-> END
