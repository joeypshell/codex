extends CharacterBody2D

signal parcel_pickup(parcel: Area2D)

const BASE_SPEED := 230.0
const BASE_PICKUP_RADIUS := 24.0
const PARCEL_TYPE_NORMAL := "normal"
const PARCEL_TYPE_FRAGILE := "fragile"
const CARRY_LIGHT_NORMAL := Color(0.62, 0.95, 1.0, 0.75)
const CARRY_LIGHT_FRAGILE := Color(1.0, 0.58, 0.82, 0.85)

@export var arena_rect := Rect2(Vector2(24, 24), Vector2(912, 492))

var carrying_parcel := false
var carried_parcel_type := PARCEL_TYPE_NORMAL
var active := true
var speed_multiplier := 1.0
var touch_direction := Vector2.ZERO

@onready var carry_light: Polygon2D = $CarryLight
@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_collision: CollisionShape2D = $PickupArea/CollisionShape2D


func _ready() -> void:
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	update_carrying(false)


func _physics_process(_delta: float) -> void:
	if not active:
		velocity = Vector2.ZERO
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if touch_direction != Vector2.ZERO:
		direction = touch_direction
	velocity = direction * BASE_SPEED * speed_multiplier
	move_and_slide()
	global_position = global_position.clamp(arena_rect.position, arena_rect.position + arena_rect.size)


func update_carrying(is_carrying: bool, parcel_type := PARCEL_TYPE_NORMAL) -> void:
	carrying_parcel = is_carrying
	carried_parcel_type = parcel_type if is_carrying else PARCEL_TYPE_NORMAL
	carry_light.visible = is_carrying
	carry_light.color = CARRY_LIGHT_FRAGILE if carried_parcel_type == PARCEL_TYPE_FRAGILE else CARRY_LIGHT_NORMAL


func set_speed_multiplier(multiplier: float) -> void:
	speed_multiplier = multiplier


func set_touch_direction(direction: Vector2) -> void:
	touch_direction = direction.normalized() if direction != Vector2.ZERO else Vector2.ZERO


func set_pickup_radius_multiplier(multiplier: float) -> void:
	var pickup_shape := pickup_collision.shape as CircleShape2D
	if pickup_shape == null:
		return
	pickup_shape.radius = BASE_PICKUP_RADIUS * multiplier


func reset_for_round(start_position: Vector2) -> void:
	global_position = start_position
	active = true
	update_carrying(false)


func stop() -> void:
	active = false
	velocity = Vector2.ZERO
	touch_direction = Vector2.ZERO


func _on_pickup_area_entered(area: Area2D) -> void:
	if not active or carrying_parcel:
		return
	if area.is_in_group("parcels"):
		parcel_pickup.emit(area)
