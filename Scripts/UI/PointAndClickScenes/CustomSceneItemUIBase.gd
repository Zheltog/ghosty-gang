class_name CustomSceneItemUIBase
extends SceneItemUI

func press_item() -> void:
	# custom logic here
	pass
	
func get_effective_interaction_type() -> INTERACTION_TYPE:
	return super.get_effective_interaction_type()
