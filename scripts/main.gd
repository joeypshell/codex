extends Node2D

enum GameState { READY, PLAYING, WON, LOST }

const TARGET_DELIVERIES := 5
const ROUND_TIME := 60.0
const HAZARD_PENALTY := 6.0
const HAZARD_TOUCH_DISTANCE := 34.0
const HAZARD_HIT_COOLDOWN := 1.0
const PLAYER_START := Vector2(110, 438)
const ARENA_RECT := Rect2(Vector2(52, 58), Vector2(856, 410))

@export var parcel_scene: PackedScene
@export var hazard_scene: PackedScene

var deliveries := 0
var time_left := ROUND_TIME
var state := GameState.READY
var hazard_hit_cooldown := 0.0
var rng := RandomNumberGenerator.new()

@onready var player = $Player
@onready var parcels = $Parcels
@onready var hazards = $Hazards
@onready var mailbox = $Mailbox
@onready var hud = $HUD


func _ready() -> void:
	rng.randomize()
	player.parcel_pickup.connect(_on_player_parcel_pickup)
	mailbox.delivery_requested.connect(_on_mailbox_delivery_requested)
	show_start_screen()


func _process(delta: float) -> void:
	if state == GameState.READY:
		if _start_pressed():
			start_round()
		return

	if state != GameState.PLAYING:
		if Input.is_action_just_pressed("restart"):
			show_start_screen()
		return

	time_left -= delta
	hazard_hit_cooldown = max(0.0, hazard_hit_cooldown - delta)
	_check_hazard_overlap()
	if time_left <= 0.0:
		end_round(false)
	else:
		hud.update_status(deliveries, TARGET_DELIVERIES, time_left, player.carrying_parcel)


func start_round() -> void:
	state = GameState.PLAYING
	deliveries = 0
	time_left = ROUND_TIME
	hazard_hit_cooldown = 0.0
	_clear_children(parcels)
	_clear_children(hazards)
	player.reset_for_round(PLAYER_START)
	hud.clear_message()
	hud.update_status(deliveries, TARGET_DELIVERIES, time_left, player.carrying_parcel)
	_spawn_hazards()
	_spawn_parcel()


func show_start_screen() -> void:
	state = GameState.READY
	deliveries = 0
	time_left = ROUND_TIME
	hazard_hit_cooldown = 0.0
	_clear_children(parcels)
	_clear_children(hazards)
	player.reset_for_round(PLAYER_START)
	player.stop()
	hud.update_status(deliveries, TARGET_DELIVERIES, time_left, player.carrying_parcel)
	hud.show_message("Firefly Courier\nDeliver 5 parcels before dawn.\nMove with WASD or arrows.\nPress Enter, Space, or move to start.")


func _start_pressed() -> bool:
	var accept_pressed := InputMap.has_action("ui_accept") and Input.is_action_just_pressed("ui_accept")
	return (
		accept_pressed
		or Input.is_action_just_pressed("move_left")
		or Input.is_action_just_pressed("move_right")
		or Input.is_action_just_pressed("move_up")
		or Input.is_action_just_pressed("move_down")
	)


func _spawn_parcel() -> void:
	if parcel_scene == null:
		return
	var parcel := parcel_scene.instantiate()
	parcels.add_child(parcel)
	parcel.global_position = _random_safe_position()


func _spawn_hazards() -> void:
	var hazard_data := [
		{"position": Vector2(300, 150), "direction": Vector2.RIGHT, "speed": 68.0, "travel": 150.0},
		{"position": Vector2(640, 220), "direction": Vector2.DOWN, "speed": 58.0, "travel": 130.0},
		{"position": Vector2(420, 380), "direction": Vector2.LEFT, "speed": 76.0, "travel": 180.0},
	]

	for data in hazard_data:
		var hazard := hazard_scene.instantiate()
		hazards.add_child(hazard)
		hazard.global_position = data["position"]
		hazard.direction = data["direction"]
		hazard.speed = data["speed"]
		hazard.travel_distance = data["travel"]
		hazard.body_entered.connect(_on_hazard_body_entered)


func _random_safe_position() -> Vector2:
	for attempt in range(24):
		var position := Vector2(
			rng.randf_range(ARENA_RECT.position.x, ARENA_RECT.end.x),
			rng.randf_range(ARENA_RECT.position.y, ARENA_RECT.end.y)
		)
		if position.distance_to(player.global_position) > 120.0 and position.distance_to(mailbox.global_position) > 90.0:
			return position
	return ARENA_RECT.get_center()


func _on_player_parcel_pickup(parcel: Area2D) -> void:
	if state != GameState.PLAYING or player.carrying_parcel:
		return
	if parcel.has_method("collect"):
		parcel.collect()
	player.update_carrying(true)
	hud.update_status(deliveries, TARGET_DELIVERIES, time_left, player.carrying_parcel)


func _on_mailbox_delivery_requested() -> void:
	if state != GameState.PLAYING or not player.carrying_parcel:
		return

	deliveries += 1
	player.update_carrying(false)
	if deliveries >= TARGET_DELIVERIES:
		end_round(true)
	else:
		_spawn_parcel()
		hud.update_status(deliveries, TARGET_DELIVERIES, time_left, player.carrying_parcel)


func _on_hazard_body_entered(body: Node2D) -> void:
	if state != GameState.PLAYING or body != player:
		return

	_apply_hazard_penalty()


func _check_hazard_overlap() -> void:
	if hazard_hit_cooldown > 0.0:
		return

	for hazard in hazards.get_children():
		if hazard is Node2D and player.global_position.distance_to(hazard.global_position) <= HAZARD_TOUCH_DISTANCE:
			_apply_hazard_penalty()
			return


func _apply_hazard_penalty() -> void:
	if hazard_hit_cooldown > 0.0:
		return

	hazard_hit_cooldown = HAZARD_HIT_COOLDOWN
	time_left = max(0.0, time_left - HAZARD_PENALTY)
	if player.carrying_parcel:
		player.update_carrying(false)
		_spawn_parcel()
	if time_left <= 0.0:
		end_round(false)
	else:
		hud.update_status(deliveries, TARGET_DELIVERIES, time_left, player.carrying_parcel)


func end_round(won: bool) -> void:
	state = GameState.WON if won else GameState.LOST
	player.stop()
	hud.update_status(deliveries, TARGET_DELIVERIES, time_left, player.carrying_parcel)
	if won:
		hud.show_message("All parcels delivered!\nPress R to start another night.")
	else:
		hud.show_message("The night ended.\nPress R to try again.")


func _clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
