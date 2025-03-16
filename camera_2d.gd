extends Camera2D

@export var movement_speed = 1000
@export var zoom_step_count = 8
@export var zoom_speed = 3
@export var map_node: Map
enum modes {NORMAL, MOVE_CAMERA}
var mode = modes.NORMAL
var max_zoom
var min_zoom
var zoom_step
var camera_size
var zoom_goal = zoom
# Percent of how far camera can see beyond the map (0.1 means 10% of view may be not map)
const max_oob_percentage = 0.1
const max_visible_map_size = 1.2
const min_visible_map_size = 0.4

func _ready() -> void:
	camera_size = Vector2(get_viewport().size)
	var map_size = map_node.size
	var min_zoom_vector = camera_size / (map_size * min(max_visible_map_size, 1 / (1 - 2 * max_oob_percentage)))
	var max_zoom_vector = camera_size / (map_size * min_visible_map_size)
	min_zoom = max(min_zoom_vector.x, min_zoom_vector.y) * Vector2.ONE
	max_zoom = min(max_zoom_vector.x, max_zoom_vector.y) * Vector2.ONE
	zoom_step = pow(max_zoom.x / min_zoom.x, 1.0 / zoom_step_count)
	@warning_ignore("integer_division")
	zoom_goal = min_zoom * pow(zoom_step, zoom_step_count / 2)
	zoom = zoom_goal

func _process(delta: float) -> void:
	if zoom != zoom_goal:
		zoom = zoom.move_toward(zoom_goal, delta * zoom_speed)
	var move: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		move.y -= delta * movement_speed
	if Input.is_action_pressed("ui_down"):
		move.y += delta * movement_speed
	if Input.is_action_pressed("ui_left"):
		move.x -= delta * movement_speed
	if Input.is_action_pressed("ui_right"):
		move.x += delta * movement_speed
	if move:
		position += move / zoom
	if Input.is_action_just_pressed("scroll_down"):
		zoom_goal /= zoom_step
	if Input.is_action_just_pressed("scroll_up"):
		zoom_goal *= zoom_step
	if Input.is_action_just_pressed("MMB"):
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		mode = modes.MOVE_CAMERA
	if Input.is_action_just_released("MMB"):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		mode = modes.NORMAL
	
	clamp_camera()
	print(zoom, "->", zoom_goal)
	print(zoom_step)
		
func clamp_camera():
	zoom = clamp(zoom, min_zoom, max_zoom)
	zoom_goal = clamp(zoom_goal, min_zoom, max_zoom)
	position.x = clamp(position.x, map_node.left + camera_size.x / zoom.x * (0.5 - max_oob_percentage) , map_node.right - camera_size.x / zoom.x * (0.5 - max_oob_percentage))
	position.y = clamp(position.y, map_node.top + camera_size.y / zoom.y * (0.5 - max_oob_percentage) , map_node.bottom - camera_size.y / zoom.y * (0.5 - max_oob_percentage))
	
	
func _input(event: InputEvent) -> void:
	if mode == modes.MOVE_CAMERA and event is InputEventMouseMotion:
		position -= event.screen_relative / zoom
