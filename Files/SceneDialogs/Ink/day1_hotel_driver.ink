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
Чего? # char:driver # anim:gruff
Семён Гало? # response # char:detective
Ну. # char:driver
Можно с вами поговорить? # response # char:detective
Дверь открывается. Водитель, в одной майке, смотрит на тебя недобро. # thought # char:driver
За его спиной смятая постель и закрытые шторы. В комнате пахнет перегаром и табаком. # thought
Чего пришел? Заплачено за номер. # char:driver
Я не из гостиницы. Мальчика ищу. # response # char:detective
Возможно, вы его сюда привезли. # response # char:detective
Семён смеряет тебя взглядом и молча уходит в глубь комнаты. # thought # char:driver
Он стучит по корпусу телевизора. После каждого удара в воздух поднимается облачко пыли. # thought # char:driver
Не включается никак, зараза. # char:driver # anim:sullen
Ты достаёшь фотографию мальчика и протягиваешь её водителю. # thought
Семён будто ее не замечает. # thought # char:driver
Куришь? # char:driver
Не курю. # response # char:detective
Тогда потом. # char:driver
Он начинает закрывать дверь. # thought # char:driver
Подождите. Мне только узнать, был он в автобусе или нет. # response # char:detective
Я сказал — потом. # char:driver
Когда потом? # response # char:detective
Семён отпускает ручку и возвращается в комнату. Ты остаёшься на пороге. # thought # char:driver
Он берёт со стола пачку, заглядывает внутрь и бросает обратно. # thought # char:driver
Как покурю. # char:driver
Ваш сменщик сказал, вы здесь остановились. С женой поругались. # response # char:detective
Семён садится на край кровати. # thought # char:driver # anim:tired
Развелись мы. # char:driver
Он сказал — поругались. # response # char:detective
Я ему так и сказал. # char:driver
Он долго трёт лицо ладонями. # thought # char:driver
Я вас не задержу. Посмотрите фотографию. # response # char:detective
Ты протягиваешь её. Семён отводит глаза. # thought # char:driver
Не могу я сейчас. # char:driver
Ребёнок пропал, Семён. # response # char:detective
Слышал я. # char:driver
Он поднимает на тебя глаза. # thought # char:driver
Принеси сигарет. Покурю, голову соберу. Тогда спрашивай. # char:driver
И поговорим? # response # char:detective
Поговорим. Дверь прикрой. Дует. # char:driver
Слышь. # char:driver
Ты оборачиваешься. # thought
-> after_driver

=== after_driver ===
~ hotel_phase = 2
~ driver_done = true
{room_return == "hotel_driver":
	Больше тут делать нечего. # window:default # thought
- else:
	Хозяйке не надо говорить. Она опять начнёт. # window:default # char:driver
}
+ [Пойти к себе в номер.]
	~ room_return = "hotel_driver"
	~ exit = "hotel_room"
	-> END
+ [Спуститься в фойе.]
	~ exit = "hotel_foyer"
	-> END
