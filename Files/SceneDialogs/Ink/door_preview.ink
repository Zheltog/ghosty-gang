EXTERNAL godot(target_class, method)
EXTERNAL godot_1(target_class, method, arg)
EXTERNAL godot_2(target_class, method, arg0, arg1)

VAR knocked = false
VAR went_inside = false

There's a wooden door...
-> fork

== fork ==
* {!knocked} [Knock]
	There is no response...
	~ knocked = true
	-> fork
+ {knocked} [Just open it]
	You open the door easily.
	-> inside

== inside ==
You slip inside...
~ godot("SceneItemDoor", "enter_house")
~ went_inside = true
-> END
