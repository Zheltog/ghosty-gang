// Чай готов. Если шкаф открыт — инженер его закрывает и требует ключ.
// Конец: инженер зовёт на кухню.
EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
# story: engineer_tea_ready
# load: suspicion, closet_open, key_returned, gun_drawn, saw_gun, explained_gun, engineer_dead
# save: suspicion, closet_open, key_returned, gun_drawn, saw_gun, explained_gun, engineer_dead

VAR suspicion = 0
VAR closet_open = false
VAR key_returned = false
VAR gun_drawn = false
VAR saw_gun = false
VAR explained_gun = false
VAR engineer_dead = false

INCLUDE gun_reaction.ink

-> begin

=== begin ===
{gun_drawn:
	-> armed
}
-> arrived

=== armed ===
-> gun ->
-> arrived

=== arrived ===
{closet_open:
	~ suspicion += 4
	-> open_closet
}
Извините, что заставил ждать. Чай готов! # window:default # char:engineer # pose:stand # anim:tea # skippable:false
Пойдёмте на кухню. # window:default # char:engineer # pose:stand # anim:tea # skippable:false
-> END

=== open_closet ===
В комнату заходит хозяин. # thought
Извините, что заставил ждать. Чай готов! # window:default # char:engineer # pose:stand # anim:tea # skippable:false
Когда он видит отодвинутый шкаф, улыбка уходит с его лица. # thought # anim:suspicion
~ godot("CustomBookshelfSceneItemUI", "close_shelf")
Он молча подходит к шкафу и захлопывает его. Затем, будто вспомнив о твоём присутствии, резко оборачивается. # thought # char:engineer # pose:stand # anim:back
Верните ключ. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false # react_default:equip:key_bookshelf:key_give, equip:gun:gun_tidy
+ [Возможно, позже.]
	~ suspicion += 1
	Возможно, позже. # response # skippable:false
	-> key_later

=== key_back ===
Пожалуйста. # response # skippable:false
~ godot_1("Inventory", "remove_item_str", "key_bookshelf")
Владислав забирает ключ и прячет его. # thought # char:engineer # pose:stand # anim:normal
-> tidy

=== key_later ===
Бровь Владислава приподнимается. # thought # char:engineer # pose:stand # anim:suspicious
Как вам угодно. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
-> tidy

=== key_give ===
~ key_returned = true
~ suspicion -= 1
-> key_back

=== gun_tidy ===
-> gun ->
-> tidy

=== tidy ===
Владислав ходит по комнате и поправляет вещи на поверхностях. Нервное? # thought # char:engineer # pose:stand # anim:back
В конце концов он останавливается. Владислав вытирает рукавом взмокший лоб и задумчиво смотрит на тебя. # thought # char:engineer # pose:stand # anim:suspicious
Чай-то будем пить? Заодно и поговорим. # response # skippable:false
Он кивает. # thought # char:engineer
Пойдёмте на кухню. Я отвечу на все ваши вопросы. # window:default # char:engineer # skippable:false
-> END
