// День 1. Второй этаж гостиницы. Выбор: свой номер или водитель.

# story: hotel_floor
# load: saw_room, room_return
# save: saw_room, room_return, exit

VAR saw_room = false
VAR room_return = ""
VAR exit = ""

-> floor

=== floor ===
{saw_room:
	Больше тут делать нечего. # window:default # thought
- else:
	Ты поднимаешься на второй этаж. # window:default # thought
}
* [Пойти к себе.]
	~ room_return = "hotel_floor"
	~ exit = "hotel_room"
	-> END
* [Заглянуть к водителю.]
	~ exit = "hotel_driver"
	-> END
