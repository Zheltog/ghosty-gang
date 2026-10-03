// Триггер: сам после engineer_return, если инженер жив.
// suspicion >= 4 — проливает чай. gun_drawn — пьёте под стволом.
# story: engineer_tea
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

-> tea

=== tea ===
{gun_drawn:
	-> tea_gun
}
{suspicion >= 4:
	-> tea_high
}
-> tea_low

=== tea_high ===
Только он начинает наливать чай, как рука дёргается. По столику расползается лужа. # thought
Ах ты. Дорогой мой, не будете любезны? Тряпка в ванной, принесите, пожалуйста. # window:default # char:engineer # anim:stand_tea
Сейчас будет. # response
Когда ты возвращаешься, чай уже налит. Владислав отхлёбывает из кружки. # thought
Пейте. Вам сейчас согреться надо. # window:default # char:engineer # anim:sit_normal
+ [Выпить]
	Взять кружку и выпить. # response
	-> drink
+ [Пусть остынет]
	Пусть сперва остынет. # response
	-> let_cool
+ [Не буду]
	Не буду я ваш чай пить. # response
	-> refuse
+ [equip:gun]
	-> arm
+ [unequip:gun]
	~ gun_drawn = false
	-> tea_high

=== tea_low ===
Инженер берёт чайник и не спеша разливает его по чашкам. # thought
Тонут во мгле пустынные сопки, тучей закрыт восток… # window:default # char:engineer # anim:stand_tea
Со смородиной? То, что доктор прописал. # response
И с мятой. Мон плезир. # window:default # char:engineer # anim:stand_smiling
Он пододвигает тебе чашку. # thought
+ [Выпить]
	Спасибо. # response
	Ты делаешь глоток. # thought
	Итак. О чём вы хотели поговорить? # window:default # char:engineer # anim:sit_normal
	-> END
+ [equip:gun]
	-> arm

=== tea_gun ===
Он садится и разливает чай. # thought
+ [unequip:gun]
	~ gun_drawn = false
	Спасибо. # response
	Ты кладёшь пистолет на стол и делаешь глоток. # thought
	-> tea
+ [action:shoot]
	-> shot

=== drink ===
Чай крепкий и немного горчит. Слова вдруг приходится выталкивать. Пальцы не слушаются. # thought
А насчёт мальчика… # response
Что… # response
Не пытайтесь встать. # window:default # char:engineer # anim:sit_shocked
Ты съезжаешь по спинке дивана. # thought
Слышите меня? # window:default # char:engineer # anim:sit_suspicious
Ответить не получается. # thought
~ engineer_poison = true
-> END

=== let_cool ===
-> END

=== refuse ===
Вы меня за кого принимаете? # window:default # char:engineer # anim:sit_suspicious
Я сказал, что не хочу. # response
Понял. И к вещам моим это тоже отношения не имеет? # window:default # char:engineer # anim:sit_suspicious
Он ставит свою чашку на стол. # thought
Извините. Не получится у нас сегодня с ночлегом. # anim:stand_default
~ engineer_kicked = true
-> END

=== arm ===
{not gun_drawn:
	~ gun_drawn = true
	~ suspicion += 5
}
-> tea_gun

=== shot ===
Выстрел. # thought # char:engineer # anim:sit_shot
# char:engineer # anim:lay_shot
~ engineer_dead = true
-> END
