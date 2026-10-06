// Триггер: EngineerDialog.road — после пожара выбран путь к инженеру.
# story: engineer_road

-> road

=== road ===
Запах гари преследует тебя всю дорогу до дома Владислава. # thought
Куда повезут водителя? # response # skippable:false
Повезут? Кто этим будет заниматься, по вашему? # window:default # char:engineer # pose:stand # anim:smiling # skippable:false
+ [Неравнодушные граждане?]
	Ну… неравнодушные граждане? # response # skippable:false
	-> citizens
+ [Промолчать]
	-> citizens

=== citizens ===
А вы этих граждан, стало быть, с собой из города привезли? # window:default # char:engineer # pose:stand # anim:smiling # skippable:false
Чего? # response # skippable:false
Не обращайте внимания. Наверное, это у меня такая реакция на стресс. Юмор, понимаете? # window:default # char:engineer # anim:smiling # skippable:false
М-да. # response # skippable:false
Думаю, до утра он так и будет лежать. А там заводские куда-нибудь его пристроят. # window:default # char:engineer # anim:default # skippable:false
Не по-людски получается. # response # skippable:false
К таким ужасам быстро привыкаешь. Спросите любого врача. Вы, конечно, тоже понимаете, о чём я. # window:default # char:engineer # anim:default # skippable:false
В каком смысле? # response # skippable:false
Вы же из милиции. К насилию привычны. # window:default # char:engineer # anim:default # skippable:false
Есть разница. # response # skippable:false
Не буду пытаться вас переубедить. # window:default # char:engineer # anim:default # skippable:false
До дома дошли молча. Трёхэтажное блочное здание выглядит заброшенным. Свет в окнах не горит. # thought
Так тихо здесь. Все уже спят. # response # skippable:false
На весь подъезд я единственный жилец. Всех расселили, а я остался. Люблю, понимаете, уединение. # window:default # char:engineer # anim:default # skippable:false
Тебе становится не по себе. # thought
-> END
