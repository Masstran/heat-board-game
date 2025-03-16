extends Node2D

class_name Space

enum spot_position {LEFT, RIGHT}

@export var first_spot_position = spot_position.LEFT

func get_first_spot():
	return get_node("spot_left") if first_spot_position == spot_position.LEFT else get_node("spot_right")
	
func get_second_spot():
	return get_node("spot_left") if first_spot_position == spot_position.RIGHT else get_node("spot_right")
