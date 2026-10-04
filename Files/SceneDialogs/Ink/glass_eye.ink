EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)

# story: glass_eye

~ godot_1("Inventory", "add_item_str", "glass_eye")
~ godot("SceneItemGlassEye", "disappear")
~ godot("EngineerDialog", "mark_glass_eye")
Среди клубов пыли ты замечаешь что-то блестящее и вытаскиваешь наружу. # window:default # skippable:true # thought
Стеклянный глаз. Отличная работа - с расстояния вытянутой руки от настоящего не отличить. # thought # skippable:true
-> END
