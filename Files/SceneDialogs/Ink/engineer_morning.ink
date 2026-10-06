// Триггер: сам после ночи.
// suspicion >= 8 и ствол не в руке — подъём под пистолетом.
// suspicion >= 8 и gun_drawn — удар доской.
# story: engineer_morning
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

-> morning

=== morning ===
{suspicion >= 8 and gun_drawn:
	-> board
}
{suspicion >= 8:
	-> pistol
}
-> calm

=== calm ===
Ты резко садишься и хватаешь себя за голову. Волосы на месте. В комнате уже светло. Где-то в квартире негромко похрапывает Владислав. # thought
Вот дрянь. # response # skippable:false
Ты складываешь одеяло, одеваешься и выходишь, стараясь не разбудить хозяина. # thought
~ engineer_leave = true
-> END

=== pistol ===
Подъём. # window:default # char:engineer # pose:none # skippable:false
Чего?.. # response # skippable:false
Что-то металлическое упирается в затылок. # thought
У меня пистолет. Без резких движений. # window:default # char:engineer # skippable:false
Руки за спину. Медленно. # pose:attack # skippable:false
Ты подчиняешься. Инженер шустро связывает их бечёвкой. # thought
Вот так. А теперь… # window:default # char:engineer # skippable:false
Рукоять врезается в висок. # thought
~ engineer_to_torture = true
-> END

=== board ===
Ай! # response # skippable:false
Ах ты, собака конторская… # window:default # char:engineer # pose:attack # anim:chair # skippable:false
Хозяин заносит доску. Ты прикрываешь голову. Правая рука нащупывает металл. # thought
Выстрел. # thought # char:engineer # pose:stand # anim:shot
Ещё один. # thought # char:engineer # pose:lay # anim:shot
Твою мать. Надо валить. # response # skippable:false
~ engineer_dead = true
-> END
