// День 1. Возвращение в гостиницу. Сон.

# story: hotel_sleep
# save: exit

VAR exit = ""

-> arrive

=== arrive ===
Ты возвращаешься в гостиницу. # window:default # thought
Хозяйка за стойкой ест быстрозавариваемое пюре, в которое крупно нарезана сосиска. # thought # char:landlady
* [Пожелать приятного аппетита.]
	Приятного аппетита! # response # char:detective # skippable:false
	Шпашибо # window:default # char:landlady # skippable:false
	Хозяйка не поднимает головы и не утруждается тщательным прожёвыванием пищи. # thought # char:landlady
	Она явно не настроена сейчас разговаривать. # thought
	-> sleep
* [Пройти мимо.]
	-> sleep

=== sleep ===
Ты идёшь к себе в номер. # window:default # thought # away:landlady
Буря за окном не утихает. # thought
Похоже, сегодня тебе уже ничего не удастся узнать, надо подождать, пока буран хотя бы позволит видеть, что находится на расстоянии вытянутой руки. # thought
Ты ложишься спать. # thought
~ exit = "night_fire"
-> END
