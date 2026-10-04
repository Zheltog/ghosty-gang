// Триггер: сам, если инженера убили, выгнали или ты ушёл утром.
# story: engineer_street
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

-> street

=== street ===
В подъезде холодно. Снаружи ещё холоднее. # thought
Соседний подъезд заперт. В следующем доме звонок работает, но никто не отвечает. В окнах темно. # thought
За спиной остаётся единственное освещённое окно. # thought
Согрелся. Спасибо. # response # skippable:false
-> END
