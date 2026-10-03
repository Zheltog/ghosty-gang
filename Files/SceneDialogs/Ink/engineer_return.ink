// Триггер: EngineerDialog.returned — осмотр закончен, инженер выходит из кухни.
// Перед вызовом: mark_closet_open, если шкаф остался отодвинут.
# story: engineer_return
# load: suspicion, closet_open, key_returned, saw_passports, has_glass_eye, gun_drawn, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, engineer_to_torture, engineer_leave, passports_raised
# save: suspicion, closet_open, key_returned, saw_passports, has_glass_eye, gun_drawn, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, engineer_to_torture, engineer_leave, passports_raised

VAR suspicion = 0
VAR closet_open = false
VAR key_returned = false
VAR saw_passports = false
VAR has_glass_eye = false
VAR gun_drawn = false
VAR engineer_dead = false
VAR engineer_poison = false
VAR engineer_kicked = false
VAR engineer_sleep = false
VAR engineer_to_torture = false
VAR engineer_leave = false
VAR passports_raised = false

-> begin

=== begin ===
{closet_open:
	~ suspicion += 4
	-> open_closet
}
Извините, что заставил ждать. Чай готов! # window:default # char:engineer # anim:stand_tea
Владислав выходит с чашками и заварником. Он ставит их на столик. # thought
-> END

=== open_closet ===
В комнату заходит хозяин: в руках пара чашек и полный заварник. # thought
Он ставит посуду на стол, подходит к шкафу и захлопывает его. # thought
Верните ключ. # window:default # char:engineer # anim:stand_suspicious
+ [equip:key_bookshelf]
	~ key_returned = true
	~ suspicion -= 1
	-> key_back
+ [Позже.]
	~ suspicion += 1
	Возможно, позже. # response
	-> key_later
+ [equip:gun]
	-> gun

=== key_back ===
Пожалуйста. # response
Владислав забирает ключ и прячет его. # thought
-> tidy

=== key_later ===
Как вам угодно. # window:default # char:engineer # anim:stand_suspicious
-> tidy

=== tidy ===
Владислав ходит по комнате и поправляет вещи. # thought
Чай-то будем пить? Заодно и поговорим. # response
Садитесь. # window:default # char:engineer # anim:sit_normal
-> END

=== gun ===
{not gun_drawn:
	~ gun_drawn = true
	~ suspicion += 5
}
Что вы делаете? Уберите его! Опустите оружие, прошу вас! # window:default # char:engineer # anim:stand_scared
+ [unequip:gun]
	~ gun_drawn = false
	-> gun_down
+ [action:shoot]
	-> gun_kill
+ [Это из вашей кладовки.]
	Это из вашей кладовки. Объяснитесь. # response
	-> gun_explain

=== gun_down ===
Господи… # window:default # char:engineer # anim:stand_default
Прошу вас, не делайте так больше. Мы же цивилизованные люди. # anim:stand_scared
-> tidy

=== gun_explain ===
Каких объяснений вы от меня хотите? У меня лицензия, всё по закону. # window:default # char:engineer # anim:stand_scared
Допустим. А паспорта? # response
Выданы партией. Поверьте мне. Это долгая история, но я могу всё объяснить. Давайте присядем, пожалуйста. # window:default # char:engineer # anim:stand_suspicious
+ [unequip:gun]
	~ gun_drawn = false
	Спасибо. # response
	Ты кладёшь пистолет на стол. # thought
	-> tidy
+ [action:shoot]
	-> gun_kill

=== gun_kill ===
Выстрел. # thought # char:engineer # anim:stand_shot
# char:engineer # anim:lay_shot
~ engineer_dead = true
-> END
