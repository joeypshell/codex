extends Area2D

@export var direction := Vector2.RIGHT
@export var speed := 70.0
@export var travel_distance := 170.0

var _start_position := Vector2.ZERO
var _traveled := 0.0


func _ready() -> void:
	add_to_group("hazards")
	_start_position = global_position
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	direction = direction.normalized()


func _physics_process(delta: float) -> void:
	var step := speed * delta
	global_position += direction * step
	_traveled = _start_position.distance_to(global_position)
	rotation += delta * 1.5
	if _traveled >= travel_distance:
		direction *= -1.0
		_start_position = global_position
		_traveled = 0.0
