// Реакция инженера на направленный пистолет.
// Вход только туннелем: -> gun ->
// Опущенный ствол возвращает в то место, откуда туннель вызвали. Выстрел кончает сюжет.

=== gun ===
~ gun_drawn = true
{not saw_gun:
	~ saw_gun = true
	~ suspicion += 5
	Что вы делаете? Уберите его! Опустите оружие, прошу вас! # window:default # char:engineer # pose:stand # anim:scared # skippable:false
- else:
	Прошу вас... # window:default # char:engineer # pose:stand # anim:scared # skippable:false
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
Господи… # window:default # char:engineer # pose:stand # anim:normal # skippable:false
Прошу вас, не делайте так больше. Мы же цивилизованные люди. # char:engineer # pose:stand # anim:scared # skippable:false
->->

=== gun_explain ===
~ explained_gun = true
Каких объяснений вы от меня хотите? У меня лицензия, всё по закону. # window:default # char:engineer # pose:stand # anim:scared # skippable:false
Допустим. А паспорта? # response # skippable:false
Выданы партией. Поверьте мне. Это долгая история, но я могу всё объяснить. Давайте присядем, пожалуйста. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
+ [unequip:gun]
	~ gun_drawn = false
	Спасибо. # response # skippable:false
	->->
+ [action:shoot]
	-> gun_kill

=== gun_kill ===
Владислав вздрагивает от выстрела и хватается рукой за грудь. Кровавое пятно расползается под его ладонью. Он раскрывает рот, будто собирается что-то сказать, но осекается и валится на пол, не издав ни звука. # thought # char:engineer # pose:stand # anim:scared
Пиздец. # response # skippable:false
~ engineer_dead = true
-> END
