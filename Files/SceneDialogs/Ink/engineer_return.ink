// Триггер: инженер выходит к игроку.
// Если шкаф открыт — закрывает его (и, если нужно, забирает ключ).
// Дальше зовёт на кухню. «Садитесь» звучит уже там; чай — после того как игрок сам сядет.
EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
# story: engineer_return
# load: suspicion, closet_open, key_returned, saw_passports, has_glass_eye, gun_drawn, saw_gun, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, engineer_to_torture, engineer_leave, passports_raised
# save: suspicion, closet_open, key_returned, saw_passports, has_glass_eye, gun_drawn, saw_gun, engineer_dead, engineer_poison, engineer_kicked, engineer_sleep, engineer_to_torture, engineer_leave, passports_raised

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
{gun_drawn:
    -> gun}
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
Верните ключ. # window:default # char:engineer # anim:stand_suspicious # skippable:false # react_default:equip:key_bookshelf:key_give, equip:gun:gun
+ [Позже.]
	~ suspicion += 1
	Возможно, позже. # response # skippable:false
	-> key_later

=== key_give ===
~ key_returned = true
~ suspicion -= 1
-> key_back

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
Чай готов, пойдемте на кухню. Я отвечу на все ваши вопросы. # window:default # char:engineer # anim:stand_tea # skippable:false
-> END

INCLUDE _engineer_gun_reaction_include.ink
