// Триггер: инженер выходит к игроку.
// Если шкаф открыт — закрывает его (и, если нужно, забирает ключ).
// Дальше зовёт на кухню. «Садитесь» звучит уже там; чай — после того как игрок сам сядет.
EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
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
Чай готов, пойдемте на кухню. # window:default # char:engineer # anim:stand_tea # skippable:false
-> END

=== open_closet ===
В комнату заходит хозяин: в руках пара чашек и полный заварник. # thought
~ godot("CustomBookshelfSceneItemUI", "close_shelf")
Он ставит посуду на стол, подходит к шкафу и захлопывает его. # thought
Верните ключ. # window:default # char:engineer # anim:stand_suspicious # skippable:false
+ [equip:key_bookshelf]
	~ key_returned = true
	~ suspicion -= 1
	-> key_back
+ [Позже.]
	~ suspicion += 1
	Возможно, позже. # response # skippable:false
	-> key_later
+ [equip:gun]
	-> gun

=== key_back ===
Пожалуйста. # response # skippable:false
~ godot_1("Inventory", "remove_item_str", "key_bookshelf")
Владислав забирает ключ и прячет его. # thought
-> tidy

=== key_later ===
Как вам угодно. # window:default # char:engineer # anim:stand_suspicious # skippable:false
-> tidy

=== tidy ===
Владислав ходит по комнате и поправляет вещи. # thought
Чай готов, пойдемте на кухню. # window:default # char:engineer # anim:stand_tea # skippable:false
-> END

=== gun ===
{not gun_drawn:
	~ gun_drawn = true
	~ suspicion += 5
}
Что вы делаете? Уберите его! Опустите оружие, прошу вас! # window:default # char:engineer # anim:stand_scared # skippable:false
+ [unequip:gun]
	~ gun_drawn = false
	-> gun_down
+ [action:shoot]
	-> gun_kill
+ [Это из вашей кладовки.]
	Это из вашей кладовки. Объяснитесь. # response # skippable:false
	-> gun_explain

=== gun_down ===
Господи… # window:default # char:engineer # anim:stand_default # skippable:false
Прошу вас, не делайте так больше. Мы же цивилизованные люди. # anim:stand_scared # skippable:false
-> tidy

=== gun_explain ===
Каких объяснений вы от меня хотите? У меня лицензия, всё по закону. # window:default # char:engineer # anim:stand_scared # skippable:false
Допустим. А паспорта? # response # skippable:false
Выданы партией. Поверьте мне. Это долгая история, но я могу всё объяснить. Давайте присядем, пожалуйста. # window:default # char:engineer # anim:stand_suspicious # skippable:false
+ [unequip:gun]
	~ gun_drawn = false
	Спасибо. # response # skippable:false
	Ты кладёшь пистолет на стол. # thought
	-> tidy
+ [action:shoot]
	-> gun_kill

=== gun_kill ===
Выстрел. # thought # char:engineer # anim:stand_shot
# char:engineer # anim:lay_shot
~ engineer_dead = true
-> END
