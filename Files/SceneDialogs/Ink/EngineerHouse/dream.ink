// Ночёвка, сон и пробуждение.
// Очень высокое подозрение — 8, как в утренней сцене. В сценарии порог не задан.
# story: dream
# load: suspicion, gun_drawn, engineer_dead, engineer_to_torture, engineer_leave
# save: suspicion, gun_drawn, engineer_dead, engineer_to_torture, engineer_leave

VAR suspicion = 0
VAR gun_drawn = false
VAR engineer_dead = false
VAR engineer_to_torture = false
VAR engineer_leave = false

-> bedding

=== bedding ===
Пожалуйста. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
Повисает пауза. # thought
Наверное, вы страшно устали. Столько всего. # window:default # char:engineer # pose:sit # anim:normal # skippable:false
Ой, не говорите. Где бы мне прилечь? # response # skippable:false
Прямо здесь. Я сейчас разложу. # window:default # char:engineer # pose:stand # anim:normal # skippable:false
Я сам. А постельное?.. # response # skippable:false
Уно моменто. Сейчас принесу. # char:engineer # pose:stand # anim:normal # skippable:false
Пока ты возишься с диваном, Владислав приносит чистое, но пахнущее шкафом бельё. # thought
Он в нерешительности топчется рядом, пока, наконец, не решается попрощаться. # thought # char:engineer # pose:stand # anim:normal
Ну-с… Добрейшей ночи! # window:default # char:engineer # pose:stand # anim:normal # skippable:false
И вам того же. Спасибо, что пустили. Выручили. # response # skippable:false
-> dream

=== dream ===
Ты лежишь с закрытыми глазами и долго ворочаешься. Сцены пожара раз за разом прокручиваются в твоей голове, постепенно сливаясь с маревом сна. # thought
Искры и дым снова окружают тебя. Ты, задыхаясь, идёшь по коридору гостиницы, который никак не заканчивается. # thought
Ты стучишься в каждый из номеров, и из них выходят обгоревшие люди — все с лицом водителя. # thought
Начальник, сигаретки не найдётся? # window:default # char:driver # skippable:false
Жену мою не видел? Увидишь, скажи, что она сука. # char:driver # skippable:false
Окно, главно, не открывай — застудимся… # char:driver # skippable:false
Мальчика ищешь? Заходи, вместе поищем. # char:driver # skippable:false
Пока не покурю, не успокоюсь. # char:driver # skippable:false
Хозяйка — стерва, со свету меня сжить хочет. # char:driver # skippable:false
Перед тобой из дыма появляется оконная рама. Ты наседаешь на неё плечом и с криком вываливаешься в снежную мглу. Сзади ты слышишь нечеловеческие вопли водителей. # thought
-> wake

=== wake ===
{suspicion >= 8 and has_gun:
	-> board
}
{suspicion >= 8:
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
Боль в голове, уже настоящая, выдёргивает тебя из сна. # thought
Аййй! # response # skippable:false
Ах ты, собака конторская… # window:default # char:engineer # pose:stand # anim:chair # skippable:false
Ты продираешь глаза и видишь, как хозяин заносит стол, чтобы нанести тебе второй удар. # thought # char:engineer # pose:stand # anim:chair
Ты прикрываешь голову левой рукой. В следующий миг её пронзает боль. Ты будто даже слышишь хруст: кость или дерево? # thought
Вдруг твоя правая рука нащупывает металл. Рефлекс срабатывает моментально. # thought
Выстрел. Ещё один. Ты открываешь глаза. # thought
Владислав, пошатываясь, делает шаг назад от кровати. Затем второй. Он раскрывает рот, будто собирается что-то сказать, но осекается и валится на пол, не издав ни звука. # thought # char:engineer # pose:stand # anim:scared
Твою мать. Твою ж мать. Надо валить. # response # skippable:false
~ engineer_dead = true
-> END
