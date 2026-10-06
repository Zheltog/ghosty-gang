// Высокое подозрение: инженер проливает чай.
// Конец: он просит сходить за тряпкой.
EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
# story: engineer_spil_tea
# load: suspicion, gun_drawn, saw_gun, explained_gun, engineer_dead, fetching_rag
# save: suspicion, gun_drawn, saw_gun, explained_gun, engineer_dead, fetching_rag

VAR suspicion = 0
VAR gun_drawn = false
VAR saw_gun = false
VAR explained_gun = false
VAR engineer_dead = false
VAR fetching_rag = false

INCLUDE gun_reaction.ink

-> begin

=== begin ===
{gun_drawn:
	-> armed
}
-> spill

=== armed ===
-> gun ->
-> spill

=== spill ===
Только он начинает наливать чай, как его рука дёргается и по лакированной поверхности столика начинает разливаться лужа. # thought # char:engineer # pose:sit # anim:suspicious
Ах ты. # window:default # char:engineer # anim:scared # skippable:false
-> ask

=== ask ===
Дорогой мой, не будете любезны?.. Тряпка в ванной, принесите, пожалуйста. # window:default # char:engineer # anim:normal # skippable:false
+ [Сейчас будет. Момент.]
	Сейчас будет. Момент. # response # skippable:false
	~ fetching_rag = true
	~ godot_1("SceneDialogManager", "process_event", "reveal_rag")
	-> END
+ [equip:gun]
	-> gun ->
	-> ask
