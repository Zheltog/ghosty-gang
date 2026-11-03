// Ночь. Пожар в гостинице «Виктория».

# story: night_fire
# load: has_cigarette_pack, met_engineer, factory_worker_introduced
# save: exit

// TODO: разделить на части по задникам
// TODO: учитывать количество оставшихся сигарет в пачке

VAR has_cigarette_pack = false
VAR met_engineer = false
VAR exit = ""
VAR factory_worker_introduced = false

-> wake

=== wake ===
Э, вот тут ещё один, доставайте его, блядь, может хотя бы он не прижарился. # window:default # char:voice # skippable:false
Тащи его наружу! # char:voice # skippable:false
Кто там шумит? Ты нехотя просыпаешься и открываешь глаза. # thought
Дверь распахивается и ты видишь перед собой тёмные фигуры на фоне светящегося красным дверного проёма. # thought
Всё происходит замедленно, будто в кино. Вокруг стоит непонятная дымка. # thought
Тебе тычут какой-то мокрой тряпкой, хватают под руки и начинают куда-то тащить. # thought
* [Спросить, что происходит.]
	Горим, блядь, что! # window:default # char:voice # skippable:false
	Ты языком особо не болтай, надышишься, за меня держись и на выход шагай. # char:voice # skippable:false
	Повязку к лицу приложи, угоришь. # char:voice # skippable:false
	-> corridor
* [Попытаться вырваться.]
	Ты вырываешься, но тебя ведёт в сторону и ты падаешь. # window:default # thought
	Почему-то очень кружится голова. # thought
	Заботливые руки поднимают тебя, дают подзатыльник и продолжают тащить. # thought
	Да не рыпайся, опездол, ты дымом надышался, за меня держись и на выход шагай. # char:voice # skippable:false
	Повязку к лицу приложи, а то совсем угоришь. # char:voice # skippable:false
	-> corridor

=== corridor ===
Держась за чьё-то плечо, ты плывёшь по коридорам гостиницы. # window:default # thought
Ноги ворочаются с трудом, но вы идёте в сторону лестницы по озаряемому багровым светом коридору. # thought
Ты чувствуешь, как в спину давит плотная стена жара, оглядываешься назад — в том конце коридора огонь пожрал уже почти всё. # thought
Вдруг ты замечаешь вырывающиеся языки пламени из номера 204. # thought
А… кх-кх… Семён… # response # char:detective # skippable:false
Семёна уже забрали, ему меньше, чем тебе повезло. # char:voice # skippable:false
Как бы не отъехал тот водитель, хе-хе-хе # char:voice # skippable:false
Успокоенный, ты окончательно обвисаешь на плече добродетеля, еле перебирая ногами. # thought
Наконец, вы вываливаетесь из гостиницы, жар отступает и теперь со всех сторон наваливается холод. # thought
Вместо дыма глаза залепляет снег, ты падаешь на колени и, покачиваясь, отплёвываешься. # thought
За спиной слышится треск, ты оглядываешься. # thought
В одном месте обвалилась крыша, надпись «Виктория» покосилась. # thought
В свете вспыхнувших искр ты видишь, что вытащил тебя мужик в форме работяги. # thought # char:factory_worker # away:voice
{factory_worker_introduced} Я его узнаю – это же Серёга. # thought
Ну всё, приплыли. # char:landlady # skippable:false
Я ему говорила не курить, поди с сигаретой уснул и кирдык, мудило, поделом ему. Аййй… # char:landlady # skippable:false
Хозяйка махнула рукой, поставила ведро, при помощи которого, очевидно, пыталась тушить пожар, перевернула его, села, и начала меланхолично смотреть на пожар, мерно покачивая головой. # thought # char:landlady
Ты протираешь глаза от снега и сажи и оглядываешься в поисках водителя. # thought
Он обнаруживается лежащим на сугробе невдалеке. # thought
Пошатываясь, ты встаёшь с колен и подходишь к нему. # thought # char:driver
Ыхххххх… С-с… # char:driver # skippable:false
Водитель сильно обгорел. Кожа лохмотьями сходит с его запечённого лица, обнажая мышцы, одежда почти не держится, в прорехах проглядывают красные и чёрные фрагменты плоти. # thought
{factory_worker_introduced:
    Если бы Серёга не поторопился, так бы мог выглядеть и я. # thought
- else:
    Если бы рабочий не поторопился, так бы мог выглядеть и я. # thought
}
Эй, позовите врача, он же откинется сейчас! # response # char:detective # skippable:false
Врач, ха, у нас последний врач в 2013 уехал. # char:factory_worker # skippable:false
Да и какой ему уже врач, парень не жилец, посмотри на него # char:factory_worker # skippable:false
У нас в Чечне и не таких откачивали, надо его отвезти в райцентр, ещё куда-то, ну нельзя же его так оставлять! # response # char:detective # skippable:false
Даю зуб, что этаких бурь «у вас в Чечне» не было. # char:factory_worker # skippable:false
Кто его повезёт сейчас, посмотри вокруг? В такую бурю, ночью… # char:factory_worker # skippable:false
Встанет машина, будет один зажаренный, другой замороженный, весёлый дуэт мертвяков «Биба и Боба». # char:factory_worker # skippable:false
Дай ему лучше сигарету на прощанье, вон, губы тянет… # char:factory_worker # skippable:false
Водитель и правда вытягивал губы вперед, будто прося сигарету. # thought # char:driver
Он весь трясся, то ли от холода, то ли от боли, то ли от всего сразу. # thought
-> cigarette

=== cigarette ===
* {has_cigarette_pack} [Дать водителю сигарету.]
	Ты достаёшь сигарету, прикуриваешь её и вставляешь Семёну в рот. # window:default # thought # char:driver
	Тот затягивается, выпускает клуб дыма, и затихает. # thought
	Тебе становится немного легче. # thought
	-> continuation
// Кончились...
* {not has_cigarette_pack} [Так не курю же…]
    Ай, ты же спортсмен… # window:default # char:factory_worker # skippable:false
	Ну, перебьётся значит, огоньку для него уже явно и так нашлось. # window:default # char:factory_worker # skippable:false
	Рабочий уходит к хозяйке, оставляя тебя сидеть с подёргивающимся и хрипящим водителем. # thought # away:factory_worker
	Ты бы многое отдал, чтобы хоть немного облегчить его страдания. # thought
	-> continuation

=== continuation ===
От пережитого шока, пригревшись жаром от горящей гостиницы, ты задрёмываешь. # thought
Ты просыпаешься от странного деревянного перестука. # thought
Уже начало светать, все зеваки разошлись, остался только ты, водитель и совсем не уставший пожар. # thought
Ты осматриваешься, и вдруг видишь рядом незнакомую женщину. # thought
Ты пытаешься понять, как она выглядит, запомнить для досье, но из-за жаркого марева её черты расплываются. # thought
Она завороженно смотрит на пожар, который окрашивает её лицо красным цветом. # thought
Вы не знаете, отчего загорелось? # response # char:detective # skippable:false
Что? # window:default # char:red_woman # skippable:false
Женщина поворачивается к тебе и ты отшатываешься. # thought
Её лицо остаётся красным, несмотря на то, что она отворотилась от огня. # thought
Кажется ей лет 20. # thought
Или 60? # thought
Не поймёшь. # thought
Пожар, вы не знаете почему пожар? # response # char:detective # skippable:false
Пожар… # window:default # char:red_woman # skippable:false
Тут всегда пожар. # window:default # char:red_woman # skippable:false
Сколько я себя помню, этот дом горел. # window:default # char:red_woman # skippable:false
Не в первый раз что ли горит? # response # char:detective # skippable:false
Горит… # window:default # char:red_woman # skippable:false
Нет никаких разов, он просто горит сколько я помню себя. # window:default # char:red_woman # skippable:false
Кто горит, тот не мёрзнет. # window:default # char:red_woman # skippable:false
Кто мёрзнет, тот послушал звёзды. # window:default # char:red_woman # skippable:false
Глупый стишок вышел. # window:default # char:red_woman # skippable:false
Лучше уж сгореть, чем мёрзнуть. # window:default # char:red_woman # skippable:false
Сгореть лучше. # window:default # char:red_woman # skippable:false
Но не всем повезло сгореть, скоро сам узнаешь. # window:default # char:red_woman # skippable:false
А может не узнаешь? # window:default # char:red_woman # skippable:false
Я хочу фасоль. # window:default # char:red_woman # skippable:false
В гостинице что-то снова рушится и тебе в лицо вылетает куча пепла, пыли и искр. # thought
Ты инстинктивно зажмуриваешься и закашливаешься а когда открываешь глаза, рядом уже никого нет. # thought
Чертовщина какая-то. # thought
Ты оглядываешься и немного в стороне ты видишь Инженера, шарящего палкой в горелом мусоре. # thought
Ты машешь ему рукой. # thought
Он замечает это, кивает и подходит к тебе. # thought
//Старик озабоченно осматривает тебя и подхватывает тебя под руку, когда ты чуть не падаешь, попытавшись встать и запнувшись о какую-то обгоревшую балку. # thought
Вы в порядке? # window:default # char:engineer # skippable:false
Зря вы так на улице сидите, так и совсем замёрзнуть недолго. # window:default # char:engineer # skippable:false
Погодите, не дергайтесь. Дайте я вас осмотрю. # window:default # char:engineer # skippable:false
Старик озабоченно оглядывает тебя со всех сторон и подхватывает тебя под руку, когда ты чуть не падаешь, запнувшись о какой-то обгоревший мусор. # thought
Тьфу, черт… # response # char:detective # skippable:false
Да в порядке все, нормально, спасибо. # response # char:detective # skippable:false
А вы тут какими судьбами? # response # char:detective # skippable:false
Да не спалось, решил пройтись, а тут вон оно что! # window:default # char:engineer # skippable:false
Ужас что происходит. # window:default # char:engineer # skippable:false
Вы как вообще? Выглядите потрёпанно. # window:default # char:engineer # skippable:false
* [Ничего, есть вон кому похуже]
    -> invitation
* [Честно? Хреново, и телу и душе]
    -> invitation
    
=== invitation ===
Конечно, понимаю… # window:default # char:engineer # skippable:false
Ну что тут поделаешь, ничего ведь не поделаешь. # window:default # char:engineer # skippable:false
Вам теперь ведь негде ночевать? # window:default # char:engineer # skippable:false
На эту ночь могу пригласить вас в своё скромное жилище. # window:default # char:engineer # skippable:false
-> END
