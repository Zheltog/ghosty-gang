// День 1. Номер 202. После осмотра возврат туда, откуда пришли.

# story: hotel_room
# load: saw_room, room_return
# save: saw_room, exit

VAR saw_room = false
VAR room_return = ""
VAR exit = ""

-> room

=== room ===
{saw_room:
	Больше тут делать нечего. # window:default # thought
	~ exit = room_return
	-> END
}
Ты проворачиваешь ключ в замке. Приходится повозиться: замок проржавел. # window:default # thought
В конце концов дверь со стоном открывается. # thought
Перед твоими глазами узкая и длинная комната. # thought
В конце — кровать, скорее койка, и тумбочка. # thought
В комнате пыльно. Одеяло свернуто, а белье просто лежит рядом. # thought
У нас в СИЗО в девяностых и то уютнее было. # response # char:detective # skippable:false
Ты бросаешь портфель на кровать и выходишь из комнаты. # thought
~ saw_room = true
~ exit = room_return
-> END
