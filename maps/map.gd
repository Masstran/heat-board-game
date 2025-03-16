extends Node2D

class_name Map

@export var space_list_scene: Node2D
@export var stress_cards_count = 3
@export var image: Sprite2D
var spaces: Array[Space]
var top
var left
var bottom
var right
var size

func _ready() -> void:
	spaces.assign(space_list_scene.get_children().filter(is_node_space))
	spaces.sort_custom(sort_by_name)
	var image_rect = image.get_rect()
	top = image_rect.position.y * scale.y
	left = image_rect.position.x * scale.x
	bottom = image_rect.end.y * scale.y
	right = image_rect.end.x * scale.x
	size = Vector2(right - left, bottom - top)

func is_node_space(node: Node2D):
	return node is Space

func sort_by_name(a, b):
	return int(a.name) < int(b.name)

	
