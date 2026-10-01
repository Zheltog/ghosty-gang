# load: suspicion
# save: suspicion
EXTERNAL godot(target_class, method)

VAR suspicion = 0

This pepper is kinda wierd... {suspicion > 0: It feels more suspicious than last time.} # window:default
-> touch

== touch ==
* [Touch it]
	~ suspicion += 1
	{ suspicion >= 2:
		~ godot("HouseScenePreview", "ghost_appear")
		There's someone in the house...
	- else:
		Nothing happens... but it feels wrong.
	}
	-> END
+ [I better not]
	-> END
