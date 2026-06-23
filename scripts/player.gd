extends CharacterBody2D

signal parcel_pickup(parcel: Area2D)

const SPEED := 230.0

@export var arena_rect := Rect2(Vector2(24, 24), Vector2(912, 492))

var carrying_parcel := false
var active := true

@onready var carry_light: Polygon2D = $CarryLight
@onready var pickup_area: Area2D = $PickupArea


func _ready() -> void:
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	update_carrying(false)


func _physics_process(_delta: float) -> void:
	if not active:
		velocity = Vector2.ZERO
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	global_position = global_position.clamp(arena_rect.position, arena_rect.position + arena_rect.size)


func update_carrying(is_carrying: bool) -> void:
	carrying_parcel = is_carrying
	carry_light.visible = is_carrying


func reset_for_round(start_position: Vector2) -> void:
	global_position = start_position
	active = true
	update_carrying(false)


func stop() -> void:
	active = false
	velocity = Vector2.ZERO


func _on_pickup_area_entered(area: Area2D) -> void:
	if not active or carrying_parcel:
		return
	if area.is_in_group("parcels"):
		parcel_pickup.emit(area)
