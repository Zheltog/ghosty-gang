class_name SceneCharacterEngineer
extends SceneCharacter

@onready var hand: AnimatedSprite2D = $Hand

func _ready() -> void:
	previous_emotion = emotion
	super._ready()

func set_emotion(new_emotion: String) -> void:
	hand.visible = new_emotion == "sit_reach"
	super.set_emotion(new_emotion)
