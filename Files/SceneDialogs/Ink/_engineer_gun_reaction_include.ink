
=== gun ===
{not saw_gun:
	~ saw_gun = true
	~ suspicion += 5
Что вы делаете? Уберите его! Опустите оружие, прошу вас! # window:default # char:engineer # anim:scared # skippable:false
- else
Прошу вас...# window:default # char:engineer # anim:scared # skippable:false
}
+ [unequip:gun]
	~ gun_drawn = false
	-> gun_down
+ [action:shoot]
	-> gun_kill
{not explained_gun:
+ [Это из вашей кладовки.]
	Это из вашей кладовки. Объяснитесь. # response # skippable:false
	-> gun_explain
}

=== gun_down ===
Господи… # window:default # char:engineer # anim:stand_default # skippable:false
Прошу вас, не делайте так больше. Мы же цивилизованные люди. # anim:stand_scared # skippable:false
-> tidy

=== gun_explain ===
~ explained_gun = true
Каких объяснений вы от меня хотите? У меня лицензия, всё по закону. # window:default # char:engineer # anim:stand_scared # skippable:false
Допустим. А паспорта? # response # skippable:false
Выданы партией. Поверьте мне. Это долгая история, но я могу всё объяснить. Давайте присядем, пожалуйста. # window:default # char:engineer # anim:stand_suspicious # skippable:false
+ [unequip:gun]
	~ gun_drawn = false
	Спасибо. # response # skippable:false
	-> tidy
+ [action:shoot]
	-> gun_kill

=== gun_kill ===
# char:engineer # anim:shot
Пиздец. #response
~ engineer_dead = true
-> END
