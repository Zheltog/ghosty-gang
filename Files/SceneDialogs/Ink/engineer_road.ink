// Триггер: EngineerDialog.road — после пожара выбран путь к инженеру.
# story: engineer_road
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

-> road

=== road ===
Запах гари преследует тебя всю дорогу до дома Владислава. # thought
Куда повезут водителя? # response # skippable:false
Повезут? Кто этим будет заниматься, по вашему? # window:default # char:engineer # anim:stand_smiling # skippable:false
+ [Неравнодушные граждане?]
	Ну… неравнодушные граждане? # response # skippable:false
	-> citizens
+ [Промолчать]
	-> citizens

=== citizens ===
А вы этих граждан, стало быть, с собой из города привезли? # window:default # char:engineer # anim:stand_smiling # skippable:false
Чего? # response # skippable:false
Не обращайте внимания. Наверное, это у меня такая реакция на стресс. Юмор, понимаете? # window:default # char:engineer # anim:stand_smiling # skippable:false
М-да. # response # skippable:false
Думаю, до утра он так и будет лежать. А там заводские куда-нибудь его пристроят. # window:default # char:engineer # anim:stand_default # skippable:false
Не по-людски получается. # response # skippable:false
К таким ужасам быстро привыкаешь. Спросите любого врача. Вы, конечно, тоже понимаете, о чём я. # window:default # char:engineer # anim:stand_default # skippable:false
В каком смысле? # response # skippable:false
Вы же из милиции. К насилию привычны. # window:default # char:engineer # anim:stand_default # skippable:false
Есть разница. # response # skippable:false
Не буду пытаться вас переубедить. # window:default # char:engineer # anim:stand_default # skippable:false
До дома дошли молча. Трёхэтажное блочное здание выглядит заброшенным. Свет в окнах не горит. # thought
Так тихо здесь. Все уже спят. # response # skippable:false
На весь подъезд я единственный жилец. Всех расселили, а я остался. Люблю, понимаете, уединение. # window:default # char:engineer # anim:stand_default # skippable:false
Тебе становится не по себе. # thought
-> END
