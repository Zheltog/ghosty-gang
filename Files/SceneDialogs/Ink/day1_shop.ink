// День 1. Магазин «Продукты». Сигареты и, если Семён уже сказал про связь, симка.
// Персонажи: cashier, detective, engineer.
// knows_sim и hotel_phase приходят из гостиницы. Покупка пишет has_cigarette туда же.
// Если сигарета нужна Семёну, уход возвращает в номер. Иначе — в фойе или на карту.

# story: shop
# load: has_cigarette, knows_sim, shop_seen, met_engineer, hotel_phase
# save: has_cigarette, shop_seen, met_engineer, exit

VAR has_cigarette = false
VAR knows_sim = false
VAR shop_seen = false
VAR met_engineer = false
VAR hotel_phase = 0
VAR exit = ""

-> shop

=== shop ===
{not shop_seen:
	С горем пополам ты выясняешь у хозяйки, где находится ближайший магазин. # window:default # thought
	Путь занимает добрых полчаса из-за гололеда и бури. # thought
	Ты оказываешься перед длинным зданием, обшитым пожелтевшим ПВХ. # thought
	Над входом краской написано «ПРОДУКТЫ». Ты заходишь внутрь. # thought
	На полупустых полках — крупы, консервы, хлеб без марки. Много пива. # thought
	~ shop_seen = true
}
Ты подходишь к кассе. # window:default # thought
-> counter

=== counter ===
Чего вам? # window:default # char:cashier # anim:bored # skippable:false
* {not has_cigarette} [Сигарет пачку. Недорогих.]
	Сигарет пачку. Недорогих. # response # char:detective # skippable:false
	Выбирайте. # window:default # char:cashier # skippable:false
	Ты наугад тыкаешь в стенд с табаком. # thought
	Продавщица протягивает тебе пачку. # thought # char:cashier
	~ has_cigarette = true
	-> counter
* {knows_sim and not met_engineer} [А симку у вас взять можно?]
	-> sim
+ [Уйти.]
	-> leave

=== sim ===
А симку у вас взять можно? # response # char:detective # skippable:false
Мужчина. У нас что тут, салон? # window:default # char:cashier # anim:sharp # skippable:false
Я без связи совсем. Что мне, в город ехать теперь? # response # char:detective # skippable:false
А я вам что, свою отдать должна? # char:cashier # skippable:false
Из-звините, мужчина… # char:engineer # anim:nervous # skippable:false
Ты оборачиваешься. # thought
Голос принадлежал щуплому старичку в больших очках с черепаховой оправой. # thought # char:engineer
Вы не на завод приехали? Спросите заводских. # char:engineer # skippable:false
Им симки раздают. Корпоративные. У кого-нибудь лишняя найдется. # char:engineer # skippable:false
Точно-точно, раздают. У меня у самой заводская, от мужа. # char:cashier # skippable:false
И детям нашим, то есть, для детей тоже принес. # char:cashier # skippable:false
Нет, я не заводской. Но спасибо за наводку. # response # char:detective # skippable:false
А зачем вы к нам пожаловали? Если не секрет, конечно. # char:engineer # anim:curious # skippable:false
У меня расследование. # response # char:detective # skippable:false
Полицейский, что ли? # char:engineer # skippable:false
Не совсем. Ищу кое-кого. # response # char:detective # skippable:false
Вот оно что… Ну, добро пожаловать в Вязи. # char:engineer # anim:smile # skippable:false
Спасибо. # response # char:detective # skippable:false
Старичок разворачивается и скрывается за полкой с пряниками. # thought # away:engineer
~ met_engineer = true
{not has_cigarette:
	-> counter
}
-> leave

=== leave ===
{
- hotel_phase >= 2 and hotel_phase < 3 and has_cigarette:
	~ exit = "hotel_interview"
- hotel_phase >= 2 and hotel_phase < 3:
	~ exit = "hotel_foyer"
- else:
	~ exit = "map"
}
-> END
