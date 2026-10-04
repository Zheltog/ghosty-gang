// Триггер: EngineerDialog.trapped — игрок забаррикадировался в кладовке.
# story: engineer_trap
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

-> trap

=== trap ===
Ты тянешь шкаф на себя. Теперь ты заперт в кладовке. # thought
Через пару минут за стеной что-то двигают. # thought
Мебель он двигает, что ли? # response # skippable:false
Шкаф не поддаётся. # thought
М-да. И что могло пойти не так? # response # skippable:false
Ты чувствуешь запах дыма. # thought
Эй! Владислав! Что ты делаешь? Давай поговорим! # response # skippable:false
Из щели начинает проникать огонь. Снаружи ни звука. # thought
Владислав! Гаси огонь! # response # skippable:false
Дым заполняет лёгкие. Всё кончено. # thought
-> END
