// Пистолет достали, когда никакой диалог не шёл.
// Реплики — туннель gun_reaction.ink. saw_gun / explained_gun / talked_about_gun
// делают следующий раз другим.
# story: gun_equip
# load: suspicion, gun_drawn, saw_gun, explained_gun, talked_about_gun, engineer_dead
# save: suspicion, gun_drawn, saw_gun, explained_gun, talked_about_gun, engineer_dead

VAR suspicion = 0
VAR gun_drawn = false
VAR saw_gun = false
VAR explained_gun = false
VAR talked_about_gun = false
VAR engineer_dead = false

INCLUDE gun_reaction.ink

-> begin

=== begin ===
-> gun ->
-> END
