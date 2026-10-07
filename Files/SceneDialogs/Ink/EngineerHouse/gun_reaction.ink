// Реакция инженера на направленный пистолет.
// Вход только туннелем: -> gun ->
// Опущенный ствол возвращает в то место, откуда туннель вызвали. Выстрел кончает сюжет.

=== gun ===
~ gun_drawn = true
{not saw_gun:
	~ saw_gun = true
	~ suspicion += 5
	Что вы делаете? Уберите его! Опустите оружие, прошу вас! # window:default # char:engineer # anim:scared # skippable:false # react_default:unequip:gun:gun_down, action:shoot:gun_kill # react_wait
- else:
	Прошу вас... # window:default # char:engineer # anim:scared # skippable:false # react_default:unequip:gun:gun_down, action:shoot:gun_kill # react_wait
}
{not explained_gun:
+ [Это из вашей кладовки.]
	Это из вашей кладовки. Объяснитесь. # response # skippable:false
	-> gun_explain
}
-> DONE

=== gun_down ===
~ gun_drawn = false
Господи… # window:default # char:engineer # anim:normal # skippable:false
Прошу вас, не делайте так больше. Мы же цивилизованные люди. # char:engineer # anim:scared # skippable:false
# react_default:
->->

=== gun_explain ===
~ explained_gun = true
Каких объяснений вы от меня хотите? У меня лицензия, всё по закону. # window:default # char:engineer # anim:scared # skippable:false # react_default:unequip:gun:gun_thanks, action:shoot:gun_kill
Допустим. А паспорта? # response # skippable:false
Выданы партией. Поверьте мне. Это долгая история, но я могу всё объяснить. Давайте присядем, пожалуйста. # window:default # char:engineer # anim:suspicious # skippable:false # react_wait
-> DONE

=== gun_thanks ===
~ gun_drawn = false
Спасибо. # response # skippable:false
# react_default:
->->

=== gun_kill ===
# react_default:
Владислав вздрагивает от выстрела и хватается рукой за грудь. Кровавое пятно расползается под его ладонью. Он раскрывает рот, будто собирается что-то сказать, но осекается и валится на пол, не издав ни звука. # thought # char:engineer # anim:scared
# char:engineer # pose:lay # anim:dead
Пиздец. # response # skippable:false
~ engineer_dead = true
-> END
