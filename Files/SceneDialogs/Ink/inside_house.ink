// Первая встреча в доме. Реакции на предметы — только текст, без смены сцены / кухни.

VAR suspicion = 0
VAR cabinet_open = true
VAR key_resolved = false
VAR has_poison = false
-> who

=== who ===
    %%Кто здесь? # anim:surprised # skippable:false # skip_default:false # timeout:4
+ [Промолчать]
	-> after_who
+ [Здравствуйте! Дверь была не заперта.]
	-> after_who
+ [equip:gun]
	-> gun -> invite
+ [equip:passport]
	-> passport -> who
+ [equip:key]
	-> key_pulled -> who

=== after_who ===
А это вы. # anim:relaxed
А ордер на обыск у вас есть? # timeout:4
+ [Промолчать]
	~ suspicion += 1
	-> joke
+ [Не совсем...]
	-> joke
+ [equip:gun]
	-> gun -> invite
+ [equip:passport]
	-> passport -> after_who
+ [equip:key]
	-> key_pulled -> after_who

=== joke ===
Я шучу, не переживайте. Это ваша работа. У нас в N отродясь проблем с домушниками не было, вот двери и не закрываем.
Вы, хочется верить, тоже меня грабить не собираетесь.
-> after_joke

=== after_joke ===
{cabinet_open:
	Инженер подходит к открытому шкафу и закрывает его.
	-> ask_key
}
-> tidy

=== ask_key ===
{key_resolved:
	-> tidy
}
Ключ у вас? # timeout:8
+ [Нет.]
	~ suspicion += 1
	~ key_resolved = true
	Значит опять попал в постиранное. Ну ничего, найдется.
	-> tidy
+ [equip:key]
	-> key_pulled -> tidy
+ [equip:gun]
	-> gun -> ask_key
+ [equip:passport]
	-> passport -> ask_key

=== tidy ===
Инженер проходит по комнате и расставляет вещи на места.
~ has_poison = true
-> invite

=== invite ===
Полагаю, у вас есть ко мне вопросы — пойдемте на кухню. Я на все отвечу.
+ [Хорошо.]
	-> END
+ [equip:gun]
	-> gun -> invite
+ [equip:passport]
	-> passport -> invite
+ [equip:key]
	-> key_pulled -> invite

=== key_pulled ===
{key_resolved:
	->->
}
Вернете?
+ [Отдать ключ]
	~ key_resolved = true
	Инженер задвигает шкаф и закрывает его.
	->->
+ [Пока нет.]
	~ suspicion += 1
	Инженер приподнимает бровь, затем кривовато улыбается.
	Материалы дела?
	->->
+ [equip:gun]
	-> gun -> key_pulled
+ [equip:passport]
	-> passport -> key_pulled

=== gun ===
{suspicion < 10: 
    ~suspicion += 10
}
%%Что это значит?! Прошу вас, опустите оружие. # anim:shocked
+ [unequip:gun]
	-> gun_holster
+ [action:shoot]
	-> gun_shoot
* [Я нашел этот пистолет в вашей кладовке.]
	-> gun_storage
* [Что ты сделал с мальчиком?]
    -> gun_boy

= gun_storage
	Все верно, это мой пистолет — у меня есть на него лицензия.
	+ [Зачем вам лицензия на огнестрел?]
		-> gun_license
	+ [unequip:gun]
		-> gun_holster
	+ [action:shoot]
		-> gun_shoot
		
= gun_license
    Я получил её в 91 году. Как и многие мои знакомые тогда.
	Это ведь не преступление хранить у себя оружие для самообороны.
	+ [unequip:gun]
		-> gun_holster
	+ [action:shoot]
		-> gun_shoot

= gun_boy
	Что? С мальчиком? Ничего я с ним не делал.
	Если я арестован, то прошу, давайте делать все по закону. Я с радостью на все отвечу, только уберите оружие.
	+ [unequip:gun]
		-> gun_holster
	+ [action:shoot]
		-> gun_shoot

= gun_holster
Прошу вас, давайте не будем так больше... #anim:relaxed
->->

= gun_shoot
#anim:fall
-> END

=== passport ===
~ suspicion += 3
Вижу, вы все-таки успели покопаться в моих вещах.
Эти документы выданы мне партией. Они поддельные, но государственные. Пойдемте на кухню, я отвечу на все по порядку.
->->
