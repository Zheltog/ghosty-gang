// Триггер: игрок сам перешёл на kitchen_couch после «Садитесь».
// suspicion >= 4 — проливает чай
EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
# story: engineer_tea
# load: suspicion, closet_open, saw_passports, gun_drawn, engineer_poison, passports_raised, fetching_rag, rag_fetched
# save: suspicion, closet_open, saw_passports, gun_drawn, engineer_poison, passports_raised, fetching_rag, rag_fetched

VAR suspicion = 0
VAR saw_passports = false
VAR gun_drawn = false
VAR passports_raised = false
VAR fetching_rag = false
VAR rag_fetched = false

-> tea

=== tea ===
{rag_fetched:
	-> tea_after_rag
}
{gun_drawn:
	-> tea_gun
}
{suspicion >= 4:
	-> tea_high
}
-> tea_low

=== tea_high ===
# char:engineer # pose:sit # anim:scared
Только он начинает наливать чай, как рука дёргается. По столику расползается лужа. # thought
Ах ты. # window:default # char:engineer # anim:scared # skippable:false
Дорогой мой, не будете любезны?.. Тряпка в ванной, принесите, пожалуйста. # window:default # char:engineer # anim:normal # skippable:false
Сейчас будет. Момент. # response # skippable:false
~ fetching_rag = true
~ godot_1("SceneDialogManager", "process_event", "reveal_rag")
-> END

=== tea_after_rag ===
Когда ты возвращаешься с тряпкой чай уже налит. Владислав с блаженным видом отхлебывает из своей кружки. # thought
Ты вытираешь лужу со столика и садишься рядом. Крепкий черный чай пахнет восхитительно - старик добавил сушеные листья смородины и мяты. # thought
Пейте. Вам сейчас согреться надо. # window:default # char:engineer # pose:sit # anim:normal # skippable:false # react_default:equip:gun:arm, unequip:gun:tea_holster
+ [Выпить]
	Взять кружку и выпить. # response # skippable:false
	-> drink
+ [Пусть остынет]
	Пусть сперва остынет. # response # skippable:false
	-> let_cool
+ [Не буду]
	Не буду я ваш чай пить. # response # skippable:false
	-> refuse

=== tea_low ===
~ godot_1("SceneDialogManager", "process_event", "reveal_tea")
Инженер берёт чайник и не спеша разливает его по чашкам. # thought
Тонут во мгле пустынные сопки, тучей закрыт восток… # window:default # char:engineer # pose:stand # anim:tea # skippable:false
Со смородиной? То, что доктор прописал. # response # skippable:false
И с мятой. Мон плезир. # window:default # char:engineer # anim:smiling # skippable:false
Он пододвигает тебе чашку. # thought # react_default:equip:gun:arm
+ [Выпить]
	Спасибо. # response # skippable:false
	Ты делаешь глоток. # thought
	Итак. О чём вы хотели поговорить? # window:default # char:engineer # pose:sit # anim:normal # skippable:false
	-> END

=== tea_gun ===
~ godot_1("SceneDialogManager", "process_event", "reveal_tea")
Он садится и разливает чай. # thought # react_default:unequip:gun:tea_gun_down, action:shoot:shot # react_wait
-> DONE

=== drink ===
Чай крепкий и немного горчит. Слова вдруг приходится выталкивать. Пальцы не слушаются. # thought
А насчёт мальчика… # response # skippable:false
Что… # response # skippable:false
Не пытайтесь встать. # window:default # char:engineer # pose:sit # anim:shocked # skippable:false
Ты съезжаешь по спинке дивана. # thought
Слышите меня? # window:default # char:engineer # anim:suspicious # skippable:false
Ответить не получается. # thought
~ engineer_poison = true
-> END

=== let_cool ===
-> END

=== refuse ===
Вы меня за кого принимаете? # window:default # char:engineer # pose:sit # anim:suspicious # skippable:false
Я сказал, что не хочу. # response # skippable:false
Понял. И к вещам моим это тоже отношения не имеет? # window:default # char:engineer # anim:suspicious # skippable:false
Он ставит свою чашку на стол. # thought
Извините. Не получится у нас сегодня с ночлегом. # pose:stand # anim:default # skippable:false
~ engineer_kicked = true
-> END

=== tea_holster ===
~ gun_drawn = false
-> tea_after_rag

=== tea_gun_down ===
~ gun_drawn = false
Спасибо. # response # skippable:false
Ты кладёшь пистолет на стол и делаешь глоток. # thought
-> tea

=== arm ===
{not gun_drawn:
	~ gun_drawn = true
	~ suspicion += 5
}
-> tea_gun

=== shot ===
Выстрел. # thought # char:engineer # pose:sit # anim:shot
# char:engineer # pose:lay # anim:shot
~ engineer_dead = true
-> END
