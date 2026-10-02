// День 1. Магазин «Продукты». Сигареты и, если Семён уже сказал про связь, симка.
// Персонажи: cashier, detective, engineer.
// knows_sim приходит из day1_hotel.ink. Покупка пишет has_cigarette туда же.

# load: has_cigarette, knows_sim, shop_seen, met_engineer
# save: has_cigarette, shop_seen, met_engineer

VAR has_cigarette = false
VAR knows_sim = false
VAR shop_seen = false
VAR met_engineer = false

-> shop

=== shop ===
{not shop_seen:
	С горем пополам ты выясняешь у хозяйки, где находится ближайший магазин. # window:default
	Путь занимает добрых полчаса из-за гололеда и бури.
	Ты оказываешься перед длинным, обшитым пожелтевшим ПВХ зданием. Над входом краской написано «ПРОДУКТЫ». Ты заходишь внутрь. На полупустых полках — стандартный ассортимент провинциального несетевого магазина. Крупы, консервы. Хлеб без марки. Много пива.
	~ shop_seen = true
}
Ты подходишь к кассе. # window:default
-> counter

=== counter ===
Чего вам? # window:default # char:cashier # anim:bored
* {not has_cigarette} [Сигарет пачку. Недорогих.]
	Сигарет пачку. Недорогих. # response # char:detective
	Выбирайте. # window:default # char:cashier
	Ты наугад тыкаешь в стенд с табаком. Продавщица протягивает тебе пачку.
	~ has_cigarette = true
	-> counter
* {knows_sim and not met_engineer} [А симку у вас взять можно?]
	-> sim
+ [Уйти.]
	-> END

=== sim ===
А симку у вас взять можно? # response # char:detective
Мужчина. У нас что тут, салон? # window:default # char:cashier # anim:sharp
Я без связи совсем. Что мне, в город ехать теперь? # response # char:detective
А я вам что, свою отдать должна? # char:cashier
Из-звините, мужчина… # char:engineer # anim:nervous
Ты оборачиваешься. Голос принадлежал щуплому старичку в больших очках с черепаховой оправой. Он как будто смутился от твоего взгляда и спрятал руки в карманы.
Вы не на завод приехали? Спросите заводских. Им симки раздают. Корпоративные. У кого-нибудь лишняя найдется. # char:engineer
Точно-точно, раздают. У меня у самой заводская, от мужа. И детям нашим, то есть, для детей тоже принес. # char:cashier
Нет, я не заводской. Но спасибо за наводку. # response # char:detective
А зачем вы к нам пожаловали? Если не секрет, конечно. # char:engineer # anim:curious
Ты замечаешь странный блеск в глазах старика.
У меня расследование. # response # char:detective
Полицейский, что ли? # char:engineer
Не совсем. Ищу кое-кого. # response # char:detective
Вот оно что… Ну, добро пожаловать в Вязи. # char:engineer # anim:smile
Он смущенно улыбается.
Спасибо. # response # char:detective
Старичок еще немного переминается с ноги на ногу, перед тем как развернуться и скрыться за полкой с пряниками.
~ met_engineer = true
{not has_cigarette:
	-> counter
}
-> END
