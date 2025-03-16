extends Node2D

class_name Car

@export var current_spot: Spot
@export var spot_to_move: Spot
@export var speed = 60.0

var spot_to_move_queue: Array[Spot] = []

# vars for movement
var pos_from
var rotation_from
var pos_to
var rotation_to
	
func set_current_spot(spot) -> void:
	if spot != null:
		current_spot = spot
		position = current_spot.global_position
		rotation = current_spot.global_rotation
		spot_to_move = null
		spot_to_move_queue = []
		clear_positions_and_rotations()

func add_spot_to_queue(spot):
	spot_to_move_queue.append(spot)


func clear_positions_and_rotations():
	pos_from = null
	rotation_from = null
	pos_to = null
	rotation_to = null
	
func set_rotations(from, to):
	rotation_from = fposmod(from, 2*PI)
	rotation_to = fposmod(to, 2*PI)
	if abs(rotation_from - rotation_to) > PI:
		# sgn(from - to) * 2PI == add 2PI if from > to and subtract 2PI if from < to
		rotation_to += abs(rotation_from - rotation_to)/(rotation_from - rotation_to) * 2*PI

func movement(delta: float):
	# We have a goal to move
	if spot_to_move != null:
		# We didn't start yet (so we are at the spot)
		if pos_from == null:
			pos_from = current_spot.global_position
			pos_to = spot_to_move.global_position
			set_rotations(current_spot.global_rotation, spot_to_move.global_rotation)
		
		var movement_delta = speed * delta
		# If that's the final spot
		if spot_to_move_queue.is_empty():
			position = position.move_toward(pos_to, movement_delta)
			var progress = min(pos_from.distance_to(position) / pos_from.distance_to(pos_to), 1)
			rotation = rotation_from + progress * (rotation_to - rotation_from)
			# We reached the destination
			if position == pos_to:
				print("REACHED SPOT ", spot_to_move.name,", YOOOO")
				clear_positions_and_rotations()
				current_spot = spot_to_move
				spot_to_move = null
				# Fix out position slightly
				set_current_spot(current_spot)
		# We still have spots to go
		else:
			var direction = (pos_to - pos_from).normalized()
			position += direction * movement_delta
			var progress = min(pos_from.distance_to(position) / pos_from.distance_to(pos_to), 1)
			rotation = rotation_from + progress * (rotation_to - rotation_from)
			# If we passed the position
			if pos_from.distance_to(position) >= pos_from.distance_to(pos_to):
				print("Passed spot ", spot_to_move.name,", yeah!")
				current_spot = spot_to_move
				spot_to_move = spot_to_move_queue.pop_front()
				
				pos_from = global_position
				pos_to = spot_to_move.global_position
				set_rotations(global_rotation, spot_to_move.global_rotation)
	else:
		spot_to_move = spot_to_move_queue.pop_front()


func _process(delta: float) -> void:
	movement(delta)
