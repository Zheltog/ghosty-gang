EXTERNAL godot(target_class, method)

# story: book_5
# load: seen_photo

VAR seen_photo = false

Б. Н. Морозов. На корешке различимы только фамилия и инициалы. Переплёт закрывает часть полки, к которой остальные книги не прилегают. # window:default # thought
{seen_photo:
	-> known
}
-> END

== known ==
Фамилия звучит знакомо. Ты вытаскиваешь книгу с полки. За ней отчетливо виднеется замочная скважина. # window:default # thought
~ godot("SceneItemBook5", "reveal_keyhole")
-> END
