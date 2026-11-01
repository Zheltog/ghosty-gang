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
    // TODO: мб, отдельная микросцена в коридоре, потому что тут у нас фон уже - номер водителя
	Ты поднимаешься по лестнице навстречу хозяйке. # window:default # thought
	Хамло! Псих! # char:landlady # anim:angry # skippable:false
	У двери тебя встречает водитель. # thought # char:driver # away:landlady
	Стерва! Нет бы мастера вызвать, технику починить. # char:driver # anim:angry # skippable:false
	Надо на честного мужика гнать. # char:driver # skippable:false
- else:
	У двери тебя встречает водитель. # window:default # thought # char:driver # anim:hands_crossed_neutral
}
Держи свою сигарету. # response # char:detective # skippable:false
Водитель хватает сигарету из твоих рук и ловко заправляет ее за ухо. # thought # char:driver # anim:cig_ear
Проходь. Садись. # char:driver # skippable:false # anim:welcome
Ты проходишь в номер и садишься на кровать. # thought
Водитель закрывает дверь за твоей спиной на щеколду. # thought # char:driver
Он наклоняется к груде одежды в углу, достает зажигалку и закуривает. # thought # char:driver # anim:cig_fire
Окно?.. # response # char:detective # skippable:false
Дурак, что ли? Застудимся. # char:driver # anim:smokin_standin_arrogant # skippable:false
Он устраивается рядом и сладко затягивается. Вы сидите молча, пока он докуривает. # thought # char:driver # anim:smokin_sittin_neutral
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
Да он ни имени, ни должности не назвал. # char:driver # anim:smokin_sittin_idk # skippable:false
Бабушка, как все бабушки. Блины, мол, жарит. Рассаду выращивает. # char:driver # skippable:false
В телефоне своем постоянно путает что-то. # char:driver # skippable:false
Людмила Игоревна Куликова. Раньше чиновница была. # response # char:detective # skippable:false
Куликова? # char:driver # anim:smokin_sittin_gloomy # skippable:false
Не помню такую. # char:driver # skippable:false
Ладно. А мальчик еще говорил что-то? # response # char:detective # skippable:false
Планы строил. Что с мамой летом на Майорку полетят. Мажор, что ли? # char:driver # skippable:false # anim:smokin_sittin_neutral
Типа того. А как с автобуса сошел? # response # char:detective # skippable:false
Встречал его кто-нибудь? # response # char:detective # skippable:false
Нет. Пустая остановка была. # char:driver # skippable:false
И ты его отпустил так просто? # response # char:detective # skippable:false
А что я? У меня маршрут. # char:driver # skippable:false # anim:smokin_sittin_idk
Понятно. # response # char:detective # skippable:false
А что с мальком-то? # char:driver # skippable:false # anim:smokin_sittin_neutral
Пропал. Ты последний его видел. # response # char:detective # skippable:false
Последний? Ё-маё… До бабки что ли не дошел? # char:driver # skippable:false
Она не в Вязи тогда была. # response # char:detective # skippable:false
Водитель сник. # thought # char:driver # anim:smokin_sittin_sad
Узнаешь что-то — иди ко мне. # response # char:detective # skippable:false

// не по сценарию - от
// Узнаешь что-то — звони мне. # response # char:detective # skippable:false
// А у тебя ловит? # char:driver # anim:downcast # skippable:false
// Вообще-то нет. Думал, из-за бури. # response # char:detective # skippable:false
// Тут только один оператор ловит нормально. Поищи симку, жить легче будет. # char:driver # skippable:false
// ~ knows_sim = true
// Учту. # response # char:detective # skippable:false
// не по сценарию - до

Удачи в поисках. Найдётся пацан. Вязь маленькая, не заблудишься. # char:driver # skippable:false
Уж надеюсь. # response # char:detective # skippable:false

// доп

Водитель встаёт, чтобы закрыть за тобой в дверь, но останавливается на полпути. # thought # char:driver # anim:smokin_standin_hands_crossed_neutral
Начальник. Садись обратно. Расскажу кой-что важное. # char:driver # skippable:false # skippable:false
В его голосе проскакивает что-то странное. # thought
Ты вздыхаешь и идешь к кровати. # thought
Перед тем, как вернуться, Семён выглядывает из-за двери, будто проверяя, не подслушивает ли кто. # thought
В конце концов он запирается и садится на стул напротив тебя. # thought # char:driver # anim:smokin_sittin_front
Что рассказать хотел? # response # char:detective # skippable:false # skippable:false
Водитель медлит. # thought
Не тяни. # response # char:detective # skippable:false # skippable:false
Дурной у нас поселок. # char:driver # skippable:false
Ну да, паршивое местечко. # response # char:detective # skippable:false # skippable:false
Ты не понял. Вещи у нас… происходят. Всякие. # char:driver # anim:smokin_sittin_finger # skippable:false
Плохие, в основном. Аварии постоянно. Связь не ловит. Крыша у людей съезжает. # char:driver # skippable:false
В трех соснах теряются. Каждую весну подснежники оттаивают. # char:driver # skippable:false
Вот был у меня сосед. Дедок обычный. Семенил все по двору с ходунками. # char:driver # skippable:false
Собак уличных кормил. С придурью дед, но в своем уме. Как-то ушел в магазин и не вернулся. # char:driver # skippable:false
А в апреле нашли его - где б ты думал? Прямо на крыше магазинной морской звездой улегся. # char:driver # skippable:false
Как забрался туда? Че он там забыл? # char:driver # skippable:false
Может, криминал? # response # char:detective # skippable:false
Тупизна какая-то получается, а не криминал. # char:driver # anim:smokin_sittin_front # skippable:false
Твоя правда. Но к чему ты это все? # response # char:detective # skippable:false
Подожди, не закончил я. # char:driver # skippable:false
Ладно старики - на склоне лет почти у всех чердак подтекает. # char:driver # skippable:false
Так ведь и с молодежью часто странности творятся. # char:driver # skippable:false
Заводской один рассказывал. Был у них бригадир приезжий, молодой совсем, только с института. # char:driver # skippable:false
Вахту неполную проработал и пропал. # char:driver # skippable:false
Через год объявился - седой как лунь. И на вид уже под пятьдесят. # char:driver # skippable:false
Говорит, проснулся в один день, вышел на улицу, а за окном никого. # char:driver # skippable:false
Пришел на завод - и там пусто. # char:driver # skippable:false
Попытался в город уехать, катит по трассе, а она его обратно возвращает. # char:driver # skippable:false
Пешком через лес уйти хотел - та же история. # char:driver # skippable:false
Так он и прожил много лет, один совсем. Крупами питался да консервой. # char:driver # skippable:false
Байки все это. # response # char:detective # skippable:false
Свечку не держал, не знаю. # char:driver # skippable:false
Только вот сплошь и рядом такое творится. # char:driver # anim:smokin_sittin_finger # skippable:false
Ну да. # response # char:detective # skippable:false
Водитель цокает и отмахивается. # thought # char:driver # anim:smokin_sittin_front
Ты не понимаешь. # char:driver # skippable:false
Да и не о том я, на самом деле, поговорить хотел. # char:driver # skippable:false
Давай скорее к делу. # response # char:detective # skippable:false
Сказки потом потравим, как мальчика отыщем. # response # char:detective # skippable:false
Дочь моя пропала. # char:driver # skippable:false
Чего? # response # char:detective # skippable:false
Дочь моя, говорю. # char:driver # skippable:false
Я потому в гостишке этой паршивой и сижу. # char:driver # skippable:false
Думаешь, что жена злая на меня? Говорит, из-за меня Алёна потерялась. # char:driver # skippable:false
Не уследил. # char:driver # skippable:false
А ты реально виноват? # response # char:detective # skippable:false
Реально. С рисования дочку должен был забрать. # char:driver # skippable:false
А я со смены такой уставший пришел, что прилег на секунду, и все, туши свет. # char:driver # skippable:false
Просыпаюсь - а уже поздно совсем. Жена с работы пришла, спрашивает, дочь где? # char:driver # skippable:false
Побежали в кружок этот. Училка говорит, Алёнка после занятия подождала немножко да ушла. # char:driver # skippable:false
Больше ее не видели. # char:driver # anim:smokin_sittin_sad # skippable:false
Давно это было? # response # char:detective # skippable:false
Недели три как. # char:driver # anim:smokin_sittin_front # skippable:false
И что? Вообще никаких зацепок нет? # response # char:detective # skippable:false
Как сквозь землю провалилась. Никто ничего не видел. # char:driver # skippable:false
Ментов вызывали из Красина. Неделю ждали. # char:driver # skippable:false
Неделю! # char:driver # anim:smokin_sittin_gloomy # skippable:false
В итоге приехали мусора эти, повздыхали, ну и укатили обратно. # char:driver # anim:smokin_sittin_front # skippable:false
А сам искал? Нашел что-то? # response # char:detective # skippable:false
Как не искать? Да толку ноль выходит. Вот только… # char:driver # skippable:false
Семён осекается, но берет себя в руки и продолжает. # thought
Только одна штука мне покоя не дает. # char:driver # anim:smokin_sittin_finger # skippable:false
Алёнка рисовала много. # char:driver # anim:smokin_sittin_front # skippable:false
Так. И что? # response # char:detective # skippable:false
Водитель разворачивает бумажку. # thought # char:driver # anim:smokin_sittin_paper
На ней изображены несколько детей и один взрослый. # thought
Голова взрослого не поместилась в рисунок, поэтому видны только его руки, которые ложатся на плечи детей, стоящих рядом с ним. # thought
Девочка и два мальчика - один повыше, другой пониже. # thought
Ты присматриваешься к тому, что пониже. # thought
Так и есть - у мальчика будто нет одного глаза. На его месте - красно-черная дыра. # thought
Жуткий пацан. # response # char:detective # skippable:false
То-то и оно. # char:driver # anim:smokin_sittin_finger # skippable:false
В школе поспрашивали - никаких одноглазых не видели. # char:driver # anim:smokin_sittin_front # skippable:false
Второго пацана тоже не узнали. # char:driver # skippable:false
Рисунок детский все-таки, не фотопортрет. # char:driver # skippable:false
Может, это из мультика какого? # response # char:detective # skippable:false
Японцы рисуют чернуху всякую, а дети смотрят потом. # response # char:detective # skippable:false
В том то и дело, что не из мультика. # char:driver # anim:smokin_sittin_finger # skippable:false
Дочка, говорю, много рисует. # char:driver # anim:smokin_sittin_front # skippable:false
Школу там, маму, меня, деревья всякие. Все подряд. Что увидит - то малюет. # char:driver # skippable:false
И, прикинь, все с натуры. Фей там, не знаю, девок анимэшных своих не рисовала никогда. # char:driver # skippable:false
Чего б ей этого страшилку придумывать? # char:driver # skippable:false
Вы еще пару минут рассматриваете странный рисунок. # thought
Ладно, Семён. Пора мне, хочу кое-кого еще опросить до ночи. # response # char:detective # skippable:false
Расскажи приметы дочки своей - тоже посматривать буду. # response # char:detective # skippable:false
Девять лет. Светленькая, курносая. Букву “Р” не выговаривает. # char:driver # skippable:false
Косички как на рисунке. В синем пуховичке была. И рюкзак голубенький. # char:driver # skippable:false
Со значками мультяшными. # char:driver # anim:smokin_sittin_sad # skippable:false
Принято. Спасибо тебе. # response # char:detective # skippable:false
Держись. Узнаю что - расскажу. # response # char:detective # skippable:false
Спасибо, что выслушал. # char:driver # anim:smokin_sittin_front # skippable:false
Береги себя. Чужих Вязь не любит. # char:driver # skippable:false
-> END

// дальше не по сценарию

// Начальник. А ты к Шнейдеру ходил уже? # char:driver # anim:wary # skippable:false
// Он тут что ли до сих пор? # response # char:detective # anim:wince # skippable:false
// А куда он денется? Без него тут ни один вопрос не решается. # char:driver # skippable:false
// Вот поэтому у вас все и идёт через жопу. # response # char:detective # skippable:false
// У тебя с ним проблемы какие-то? # char:driver # skippable:false
// Мягко сказано. # response # char:detective # skippable:false
// А ты все равно сходи. Если кто и поможет, то только он. # char:driver # skippable:false
// Обойдусь. # response # char:detective # skippable:false
// -> street

// === street ===
// ~ hotel_phase = 3
// Ты на улице. # window:default # thought # away:driver
// * [Пойти к бабушке.]
	// В сценарии ветка не прописана.
// 	~ exit = "map"
// 	-> END
// * [Пойти к шестерке.]
	// В сценарии ветка не прописана.
// 	~ exit = "map"
// 	-> END
// * [Пойти в магазин.]
// 	~ exit = "shop"
// 	-> END
