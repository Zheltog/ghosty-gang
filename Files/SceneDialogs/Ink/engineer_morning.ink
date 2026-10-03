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
Вот дрянь. # response
Ты складываешь одеяло, одеваешься и выходишь, стараясь не разбудить хозяина. # thought
~ engineer_leave = true
-> END

=== pistol ===
Подъём. # window:default # char:engineer # anim:close
Чего?.. # response
Что-то металлическое упирается в затылок. # thought
У меня пистолет. Без резких движений. # window:default # char:engineer # anim:close
Руки за спину. Медленно. # anim:attack_chair
Ты подчиняешься. Инженер шустро связывает их бечёвкой. # thought
Вот так. А теперь… # window:default # char:engineer # anim:close
Рукоять врезается в висок. # thought
~ engineer_to_torture = true
-> END

=== board ===
Ай! # response
Ах ты, собака конторская… # window:default # char:engineer # anim:attack_chair
Хозяин заносит доску. Ты прикрываешь голову. Правая рука нащупывает металл. # thought
Выстрел. # thought # char:engineer # anim:stand_shot
Ещё один. # thought # char:engineer # anim:lay_shot
Твою мать. Надо валить. # response
~ engineer_dead = true
-> END
