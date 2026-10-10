// Пробуждение.
// Очень высокое подозрение — 8, как в утренней сцене. В сценарии порог не задан.
EXTERNAL godot_1(target_class, method, arg)

# story: wake
# load: suspicion, gun_drawn, engineer_dead, engineer_to_torture, engineer_leave
# save: suspicion, gun_drawn, engineer_dead, engineer_to_torture, engineer_leave

VAR suspicion = 0
VAR gun_drawn = false
VAR engineer_dead = false
VAR engineer_to_torture = false
VAR engineer_leave = false

-> wake

=== wake ===
{suspicion >= 3 and godot_1("Inventory", "has_item_str", "gun"):
	-> board
}
{suspicion >= 3:
	-> pistol
}
-> calm

=== calm ===
Ты резко садишься в кровати. Несколько секунд ты сидишь, вцепившись в одеяло, и смотришь на книжный шкаф, пока наконец не вспоминаешь, где находишься. # thought
В комнате уже светло. За окном серое небо, на столике — вчерашние чашки. Ты трогаешь затылок ещё раз. # thought
Вот дрянь. # response # skippable:false
Ты прислушиваешься. Где-то в квартире негромко похрапывает Владислав. # thought
Спать больше не хочется. Во рту сухо, под рубашкой липнет пот. Ты спускаешь ноги с дивана и некоторое время сидишь, упираясь локтями в колени. # thought
Вставать не хочется тоже, но тут уж выбирать не приходится. # thought
Одеяло ты складываешь и оставляешь вместе с подушкой на диване. # thought
Пора идти. Хозяина будить незачем — ещё решит, что я собрался продолжить вчерашний опрос. # response # skippable:false
В прихожей ты одеваешься, стараясь не шуметь. Одежда по-прежнему пахнет гарью. Ты натягиваешь ворот повыше, но становится только хуже: теперь запах прямо под носом. # thought
Обувшись, ты осторожно нажимаешь на дверную ручку. Язычок замка щёлкает так громко, что ты замираешь. В квартире перестают храпеть. # thought
Ты ждёшь. # thought
Храп возобновляется. Ты выходишь на площадку и медленно прикрываешь дверь. # thought
На лестнице приходится остановиться и растереть лицо. После тёплой квартиры холод быстро приводит тебя в чувство. Через мутное стекло подъездного окна виден двор: пустой, засыпанный снегом. # thought
Ты застёгиваешь куртку до конца и выходишь. # thought
~ engineer_leave = true
-> END

=== pistol ===
Подъём. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Чего?.. # response # skippable:false
Чувства возвращаются к тебе, и первое из них — что-то металлическое упирается в твой затылок. # thought
У меня пистолет. Без резких движений. # window:default # char:engineer # pose:stand # anim:suspicious # skippable:false
Ты медленно поднимаешься и садишься на кровать. # thought
Руки за спину. Медленно. # window:default # char:engineer # pose:stand # anim:normal # skippable:false
Ты подчиняешься. Инженер шустро связывает их бечёвкой. # thought
Вот так. А теперь… # window:default # char:engineer # pose:stand # anim:chair # skippable:false
Ты успеваешь увидеть только резкое движение тени, как рукоять пистолета врезается в твой висок. Сознание покидает тебя. # thought
~ engineer_to_torture = true
-> END

=== board ===
# char:engineer # pose:stand # anim:suspicious # skippable:false
~ godot_1("CommonAudioProcessor", "play_sound", "wood")
Боль в голове, уже настоящая, выдёргивает тебя из сна. # thought
Аййй! # response # skippable:false
Ах ты, собака конторская… # window:default # char:engineer # pose:stand # anim:chair # skippable:false
Ты продираешь глаза и видишь, как хозяин заносит стул, чтобы нанести тебе второй удар. # thought # char:engineer # pose:stand # anim:chair
Ты прикрываешь голову левой рукой. В следующий миг её пронзает боль. Ты будто даже слышишь хруст: кость или дерево? # thought
Вдруг твоя правая рука нащупывает металл. Рефлекс срабатывает моментально. # thought
~ godot_1("CommonAudioProcessor", "play_sound", "gun")
Выстрел. Ты открываешь глаза. # thought
Владислав, пошатываясь, делает шаг назад от кровати. Затем второй. Он раскрывает рот, будто собирается что-то сказать, но осекается и валится на пол, не издав ни звука. # thought # char:engineer # pose:stand # anim:scared
# char:engineer # pose:lay # anim:dead
Твою мать. Твою ж мать. Надо валить. # response # skippable:false
~ engineer_dead = true
-> END
