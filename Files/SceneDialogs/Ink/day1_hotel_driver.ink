// День 1. Номер 204. Первый разговор с Семёном, пока без сигареты.

# story: hotel_driver
# load: driver_done, room_return, hotel_phase
# save: driver_done, room_return, hotel_phase, exit

VAR driver_done = false
VAR room_return = ""
VAR hotel_phase = 0
VAR exit = ""

-> begin

=== begin ===
{driver_done:
	-> after_driver
}
Из-за двери номера 204 доносится телевизор. # window:default # thought
После второго стука звук пропадает. # thought
Чего? # char:driver # skippable:false
Семён Гало? # response # char:detective # skippable:false
Ну. # char:driver # skippable:false
Можно с вами поговорить? # response # char:detective # skippable:false
Дверь открывается. Водитель смотрит на тебя недобро. # thought # char:driver # anim:arms_akimbo_gloomy
За его спиной смятая постель и закрытые шторы. В комнате пахнет перегаром и табаком. # thought
Чего пришел? Заплачено за номер. # char:driver # skippable:false
Я не из гостиницы. Детектив я. Мальчика ищу. # response # char:detective # skippable:false
Возможно, вы его сюда привезли. # response # char:detective # skippable:false
Семён молча уходит в глубь комнаты. # thought # char:driver # anim:bb
Он стучит по корпусу телевизора. После каждого удара в воздух поднимается облачко пыли. # thought # char:driver # anim:tv_punch
Не включается никак, зараза. # char:driver # skippable:false
Ты достаёшь фотографию мальчика и протягиваешь её водителю. # thought
Куришь? # char:driver # anim:do_u_smoke # skippable:false
Не курю. # response # char:detective # skippable:false
Тогда потом. # char:driver # anim:bb # skippable:false
Он начинает закрывать дверь. # thought # char:driver
Подождите. Мне только узнать, был он в автобусе или нет. # response # char:detective # skippable:false
Я сказал — потом. # char:driver # skippable:false
Когда потом? # response # char:detective # skippable:false
Семён отпускает ручку и возвращается в комнату. Ты остаёшься на пороге. # thought # char:driver
Он берёт со стола пачку, заглядывает внутрь и бросает обратно. # thought # anim:pack_check # char:driver
Как покурю. # char:driver # anim:do_u_smoke # skippable:false
Ваш сменщик сказал, вы здесь остановились. С женой поругались. # response # char:detective # skippable:false
Семён садится на край кровати. # thought # char:driver # anim:hands_crossed_neutral
Развелись мы. # char:driver # skippable:false
Он сказал — поругались. # response # char:detective # skippable:false
Я ему так и сказал. # char:driver # skippable:false
Я вас не задержу. Посмотрите фотографию. # response # char:detective # skippable:false
Ты протягиваешь её. # thought
Не могу я сейчас. # char:driver # skippable:false
Ребёнок пропал, Семён. # response # char:detective # skippable:false
Слышал я. # char:driver # skippable:false
Принеси сигарет. Покурю, голову соберу. Тогда спрашивай. # char:driver # skippable:false
И поговорим? # response # char:detective # skippable:false
Поговорим. Дверь прикрой. Дует. # char:driver # skippable:false
Слышь. # char:driver # skippable:false
Ты оборачиваешься. # thought
-> after_driver

=== after_driver ===
~ hotel_phase = 2
~ driver_done = true
{room_return == "hotel_driver":
	Больше тут делать нечего. # window:default # thought
- else:
	Хозяйке не надо говорить. Она опять начнёт. # window:default # char:driver # anim:pointing # skippable:false
}
+ [Пойти к себе в номер.]
	~ room_return = "hotel_driver"
	~ exit = "hotel_room"
	-> END
+ [Спуститься в фойе.]
	~ exit = "hotel_foyer"
	-> END
