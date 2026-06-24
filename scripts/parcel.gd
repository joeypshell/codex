extends Area2D

const TYPE_NORMAL := "normal"
const TYPE_FRAGILE := "fragile"

@export var parcel_type := TYPE_NORMAL

var collected := false

@onready var glow: Polygon2D = $Glow
@onready var body: Polygon2D = $Body
@onready var ribbon: ColorRect = $Ribbon


func _ready() -> void:
	add_to_group("parcels")
	_apply_visuals()


func set_parcel_type(new_type: String) -> void:
	if new_type != TYPE_FRAGILE:
		new_type = TYPE_NORMAL
	parcel_type = new_type
	if is_node_ready():
		_apply_visuals()


func get_parcel_type() -> String:
	return parcel_type


func collect() -> void:
	if collected:
		return
	collected = true
	queue_free()


func _apply_visuals() -> void:
	if parcel_type == TYPE_FRAGILE:
		glow.color = Color(1.0, 0.58, 0.82, 0.28)
		body.color = Color(1.0, 0.58, 0.82, 1.0)
		ribbon.color = Color(1.0, 0.95, 0.55, 0.85)
	else:
		glow.color = Color(0.62, 0.95, 1.0, 0.24)
		body.color = Color(0.62, 0.95, 1.0, 1.0)
		ribbon.color = Color(1.0, 1.0, 1.0, 0.65)
