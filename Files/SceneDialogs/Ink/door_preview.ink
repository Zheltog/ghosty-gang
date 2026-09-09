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
~ went_inside = true
-> END