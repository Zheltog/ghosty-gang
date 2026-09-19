-> start

=== start ===
Привет! Я машу рукой. # anim:wave # pos:top_right
У этой строки тега нет — должна остаться idle.
Ого, вот это поворот! # anim:surprised # pos:bottom_left
Такой анимации не существует — ждём предупреждение и откат на idle. # anim:jump_over_the_moon
+ [Помахать ещё раз]
	Машу снова. # anim:wave
	И ещё раз подряд — перезапуска быть не должно. # anim:wave
	-> start
+ [Погрустить]
	Мне немного грустно. # anim:sad
	-> start
+ [Закончить тест]
	-> ending

=== ending ===
Тест закончен. # anim:idle # pos:top_right
-> END
