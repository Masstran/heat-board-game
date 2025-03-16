extends Node2D

class_name Map

@export var space_list_scene: Node2D
@export var top_left: Marker2D
@export var bottom_right: Marker2D
@export var stress_cards_count = 3
var spaces: Array[Space]
var top
var left
var bottom
var right
var size

func _ready() -> void:
	spaces.assign(space_list_scene.get_children().filter(is_node_space))
	spaces.sort_custom(sort_by_name)
	top = top_left.global_position.y
	left = top_left.global_position.x
	bottom = bottom_right.global_position.y
	right = bottom_right.global_position.x
	size = abs(top_left.global_position - bottom_right.global_position)

func is_node_space(node: Node2D):
	return node is Space

func sort_by_name(a, b):
	return int(a.name) < int(b.name)

	
