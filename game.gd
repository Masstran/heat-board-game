extends Node2D

@export var map_scene: Map
@export var car_scene: Car

var counter = 0

func set_current_space() -> void:
	car_scene.set_current_spot(map_scene.spaces[counter].get_first_spot())

func set_new_space():
	counter = (counter + 1) % len(map_scene.spaces)
	car_scene.add_spot_to_queue(map_scene.spaces[counter].get_first_spot())
	
func move_n_spaces(n: int):
	for i in range(n):
		set_new_space()
			
	
func _ready() -> void:
	car_scene.set_current_spot(map_scene.spaces[0].get_first_spot())

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("set_current_space")):
		set_current_space()
	if (Input.is_action_just_pressed("set_space_to_move")):
		set_new_space()
	if (Input.is_action_just_pressed("move_10_spaces")):
		move_n_spaces(10)
