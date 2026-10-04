EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
EXTERNAL godot_2(target_class, method, arg0, arg1)

VAR knocked = false
VAR went_inside = false

There's a wooden door... # window:default # thought
-> fork

== fork ==
* {!knocked} [Knock]
	There is no response... # thought
	~ knocked = true
	-> fork
+ {knocked} [Just open it]
	You open the door easily. # thought
	-> inside

== inside ==
You slip inside... # thought
~ godot("SceneItemDoor", "enter_house")
~ went_inside = true
-> END
