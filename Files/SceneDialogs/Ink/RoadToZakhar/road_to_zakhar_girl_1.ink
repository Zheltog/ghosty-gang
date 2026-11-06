// День ?. Путь к Захару, встреча и разговор с дочкой Водителя (Алёной).
// Персонажи: detective, driver_daughter.
// Мысли и ремарки — # thought, их говорит none.
// Дальше: road_to_zakhar_girl_2.ink

# save: driver_daughter_introduced

VAR driver_daughter_introduced = false

EXTERNAL godot_1(target_class, method, arg)

-> talk_with_girl_1

=== talk_with_girl_1 ===
Когда твой взгляд возвращается к идущим людям, оказывается, что впереди идет только один ребенок. # thought
Девочка - а это оказывается девочка - с удивлением оглядывается на тебя. # thought
Ой! А вы тут откуда? # char:driver_daughter # skippable:false
А где… Где мама твоя? # response # char:detective # skippable:false
На лаботе, навелно. # char:driver_daughter # skippable:false
А женщина с тобой? # response # char:detective # skippable:false
А, так она тут, лядом. # char:driver_daughter # skippable:false
Только она с вами не будет лазговаливать больше. # char:driver_daughter # skippable:false
Говолит, все лавно не услышите. # char:driver_daughter # skippable:false
Чего?.. # response # char:detective # skippable:false
Ты это… Ты это прекращай. # response # char:detective # skippable:false
Взрослый, говорю, есть кто? # response # char:detective # skippable:false
Помощь мне нужна. # response # char:detective # skippable:false
Ещё папа мой. # char:driver_daughter # skippable:false
Только он тепель не совсем взлослый, он почти как я. # char:driver_daughter # skippable:false
Малявка говорит медленно, и смотрит на тебя так, будто это ты тут ребенок, а она тебе объясняет самые простые вещи. # thought
Ты замечаешь, что она смотрит на твою рану. # thought
Она будто совсем не боится твоего страшного вида. # thought
А ведь выглядишь ты, должно быть, и правда хреново. # thought
Весь в кровище, рвоте. # thought
Вам бы отдохнуть. # char:driver_daughter # skippable:false
Ты в отчаянии садишься на корточки. # thought
Что вообще тут происходит? # thought
Куда женщина могла деться посреди улицы? # thought
Вокруг всё закрыто. # thought
// Девочка сочувствующе смотрит на тебя. # thought
Мне тут тоже страшно было спелва, а потом как-то попривыкла. # char:driver_daughter # skippable:false
Тут еще со мной лебята, и тётя класная. # char:driver_daughter # skippable:false
Она мне леденцы дала, “взлётные”. # char:driver_daughter # skippable:false
Давайте я и с вами немножко поделюсь. # char:driver_daughter # skippable:false
Девочка лезет в карман своей васильковой курточки, достает оттуда целую горсть конфет и протягивает тебе. # thought
Но ты на них не смотришь. # thought
Ты смотришь на девочку. # thought
Слушай… # response # char:detective # skippable:false
А тебя не Алёной зовут? # response # char:detective # skippable:false
Алёна. # char:driver_daughter # skippable:false
~ driver_daughter_introduced = true
~ godot_1("SceneDialogManager", "process_event", "girl_2")
-> END
