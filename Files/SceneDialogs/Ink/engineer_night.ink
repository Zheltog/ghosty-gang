// Триггер: сам после опроса, когда сказано «на сегодня хватит».
# story: engineer_night
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

-> night

=== night ===
Пожалуйста. # window:default # char:engineer # anim:sit_normal
Наверное, вы страшно устали. Столько всего. # anim:sit_normal
Ой, не говорите. Где бы мне прилечь? # response
Прямо здесь. Я сейчас разложу. # window:default # char:engineer # anim:stand_default
Я сам. А постельное? # response
Уно моменто. Сейчас принесу. # anim:stand_smiling
Пока ты возишься с диваном, Владислав приносит бельё. # thought
Ну-с… Добрейшей ночи! # window:default # char:engineer # anim:stand_smiling
И вам того же. Спасибо, что пустили. # response
Ты долго ворочаешься. Пожар сливается со сном: коридор гостиницы, обгоревшие люди с лицом водителя, женщина с алым лицом гладит тебя по волосам, и жар становится невыносимым. # thought
-> END
