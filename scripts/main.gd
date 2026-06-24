extends Node2D

enum GameState { READY, PLAYING, FLOOR_CLEAR, LOST }

const TARGET_DELIVERIES := 5
const BASE_FLOOR_TIME := 60.0
const MIN_FLOOR_TIME := 35.0
const FLOOR_TIME_STEP := 2.0
const BASE_HAZARD_COUNT := 3
const MAX_HAZARD_COUNT := 6
const HAZARD_COUNT_FLOOR_INTERVAL := 3
const BASE_HAZARD_SPEED_MULTIPLIER := 1.0
const MAX_HAZARD_SPEED_MULTIPLIER := 1.8
const HAZARD_SPEED_PER_FLOOR := 0.08
const HAZARD_PENALTY := 6.0
const FRAGILE_HAZARD_PENALTY := 12.0
const HAZARD_TOUCH_DISTANCE := 34.0
const HAZARD_HIT_COOLDOWN := 1.0
const PICKUP_EVENT_COLOR := Color(0.62, 0.95, 1.0)
const DELIVERY_EVENT_COLOR := Color(1.0, 0.92, 0.35)
const HAZARD_EVENT_COLOR := Color(1.0, 0.36, 0.36)
const UPGRADE_EVENT_COLOR := Color(0.82, 1.0, 0.58)
const PARCEL_TYPE_NORMAL := "normal"
const PARCEL_TYPE_FRAGILE := "fragile"
const FIRST_FRAGILE_DELIVERY := 1
const FRAGILE_DELIVERY_INTERVAL := 2
const BASE_FRAGILE_CHANCE := 0.25
const FRAGILE_CHANCE_PER_FLOOR := 0.08
const MAX_FRAGILE_CHANCE := 0.75
const PLAYER_START := Vector2(110, 438)
const ARENA_RECT := Rect2(Vector2(52, 58), Vector2(856, 410))
const UPGRADE_BRIGHTER_WINGS := "brighter_wings"
const UPGRADE_MOONLIT_MINUTE := "moonlit_minute"
const UPGRADE_GENTLE_HANDLING := "gentle_handling"
const UPGRADE_LUCKY_SATCHEL := "lucky_satchel"
const UPGRADE_WIDE_GLOW := "wide_glow"
const BRIGHTER_WINGS_SPEED_BONUS := 0.10
const BRIGHTER_WINGS_MAX_STACKS := 3
const MOONLIT_MINUTE_TIME_BONUS := 8.0
const MOONLIT_MINUTE_MAX_STACKS := 3
const GENTLE_HANDLING_PENALTY_REDUCTION := 2.0
const GENTLE_HANDLING_MAX_STACKS := 2
const LUCKY_SATCHEL_PENALTY_REDUCTION := 1.0
const LUCKY_SATCHEL_MAX_STACKS := 2
const WIDE_GLOW_RADIUS_BONUS := 0.15
const WIDE_GLOW_MAX_STACKS := 2
const UPGRADE_POOL := [
	{"id": UPGRADE_BRIGHTER_WINGS, "name": "Brighter Wings"},
	{"id": UPGRADE_MOONLIT_MINUTE, "name": "Moonlit Minute"},
	{"id": UPGRADE_GENTLE_HANDLING, "name": "Gentle Handling"},
	{"id": UPGRADE_LUCKY_SATCHEL, "name": "Lucky Satchel"},
	{"id": UPGRADE_WIDE_GLOW, "name": "Wide Glow"},
]

@export var parcel_scene: PackedScene
@export var hazard_scene: PackedScene

var deliveries := 0
var total_deliveries := 0
var floor_number := 1
var best_floor := 1
var time_left := BASE_FLOOR_TIME
var state := GameState.READY
var hazard_hit_cooldown := 0.0
var rng := RandomNumberGenerator.new()
var chosen_upgrades: Array[String] = []
var pending_upgrade_options: Array[Dictionary] = []

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
			start_run()
		return

	if state == GameState.FLOOR_CLEAR:
		if Input.is_action_just_pressed("restart"):
			show_start_screen()
		return

	if state == GameState.LOST:
		if Input.is_action_just_pressed("restart"):
			show_start_screen()
		return

	time_left -= delta
	hazard_hit_cooldown = max(0.0, hazard_hit_cooldown - delta)
	_check_hazard_overlap()
	if time_left <= 0.0:
		end_run()
	else:
		_update_hud()


func start_run() -> void:
	floor_number = 1
	total_deliveries = 0
	chosen_upgrades.clear()
	pending_upgrade_options.clear()
	best_floor = max(best_floor, floor_number)
	start_floor()


func advance_floor() -> void:
	floor_number += 1
	best_floor = max(best_floor, floor_number)
	start_floor()


func start_floor() -> void:
	state = GameState.PLAYING
	deliveries = 0
	time_left = _floor_time()
	hazard_hit_cooldown = 0.0
	_clear_children(parcels)
	_clear_children(hazards)
	player.reset_for_round(PLAYER_START)
	_apply_upgrade_effects()
	hud.clear_message()
	_update_hud()
	_spawn_hazards()
	_spawn_next_parcel()


func show_start_screen() -> void:
	state = GameState.READY
	floor_number = 1
	total_deliveries = 0
	deliveries = 0
	chosen_upgrades.clear()
	pending_upgrade_options.clear()
	time_left = _floor_time()
	hazard_hit_cooldown = 0.0
	_clear_children(parcels)
	_clear_children(hazards)
	player.reset_for_round(PLAYER_START)
	_apply_upgrade_effects()
	player.stop()
	_update_hud()
	hud.show_message("Firefly Courier\nDeliver 5 parcels to clear each floor.\nMove with WASD or arrows.\nPress Enter, Space, or move to start.")


func _start_pressed() -> bool:
	var accept_pressed := InputMap.has_action("ui_accept") and Input.is_action_just_pressed("ui_accept")
	return (
		accept_pressed
		or Input.is_action_just_pressed("move_left")
		or Input.is_action_just_pressed("move_right")
		or Input.is_action_just_pressed("move_up")
		or Input.is_action_just_pressed("move_down")
	)


func _spawn_parcel(parcel_type := PARCEL_TYPE_NORMAL) -> void:
	if parcel_scene == null:
		return
	var parcel := parcel_scene.instantiate()
	parcels.add_child(parcel)
	if parcel.has_method("set_parcel_type"):
		parcel.call("set_parcel_type", parcel_type)
	parcel.global_position = _random_safe_position()


func _spawn_next_parcel() -> void:
	_spawn_parcel(_next_parcel_type())


func _next_parcel_type() -> String:
	if floor_number >= 2:
		return PARCEL_TYPE_FRAGILE if rng.randf() < _fragile_parcel_chance() else PARCEL_TYPE_NORMAL
	if deliveries < FIRST_FRAGILE_DELIVERY:
		return PARCEL_TYPE_NORMAL
	return PARCEL_TYPE_FRAGILE if deliveries % FRAGILE_DELIVERY_INTERVAL == 1 else PARCEL_TYPE_NORMAL


func _fragile_parcel_chance() -> float:
	return min(MAX_FRAGILE_CHANCE, BASE_FRAGILE_CHANCE + (floor_number * FRAGILE_CHANCE_PER_FLOOR))


func _spawn_hazards() -> void:
	var hazard_data := [
		{"position": Vector2(300, 150), "direction": Vector2.RIGHT, "speed": 68.0, "travel": 150.0},
		{"position": Vector2(640, 220), "direction": Vector2.DOWN, "speed": 58.0, "travel": 130.0},
		{"position": Vector2(420, 380), "direction": Vector2.LEFT, "speed": 76.0, "travel": 180.0},
		{"position": Vector2(210, 310), "direction": Vector2.DOWN, "speed": 64.0, "travel": 120.0},
		{"position": Vector2(740, 360), "direction": Vector2.LEFT, "speed": 70.0, "travel": 150.0},
		{"position": Vector2(520, 110), "direction": Vector2.RIGHT, "speed": 62.0, "travel": 130.0},
	]
	var hazard_count: int = mini(_hazard_count(), hazard_data.size())
	var speed_multiplier := _hazard_speed_multiplier()

	for index in range(hazard_count):
		var data: Dictionary = hazard_data[index]
		var hazard := hazard_scene.instantiate()
		hazards.add_child(hazard)
		hazard.global_position = data["position"] as Vector2
		hazard.direction = data["direction"] as Vector2
		hazard.speed = float(data["speed"]) * speed_multiplier
		hazard.travel_distance = float(data["travel"])
		hazard.body_entered.connect(_on_hazard_body_entered)


func _floor_time() -> float:
	var upgrade_bonus := _upgrade_stack_count(UPGRADE_MOONLIT_MINUTE) * MOONLIT_MINUTE_TIME_BONUS
	return max(MIN_FLOOR_TIME, BASE_FLOOR_TIME - (floor_number * FLOOR_TIME_STEP)) + upgrade_bonus


func _hazard_count() -> int:
	var floor_bonus := floori(float(floor_number) / float(HAZARD_COUNT_FLOOR_INTERVAL))
	return min(MAX_HAZARD_COUNT, BASE_HAZARD_COUNT + floor_bonus)


func _hazard_speed_multiplier() -> float:
	return min(MAX_HAZARD_SPEED_MULTIPLIER, BASE_HAZARD_SPEED_MULTIPLIER + (floor_number * HAZARD_SPEED_PER_FLOOR))


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
	var parcel_type := PARCEL_TYPE_NORMAL
	if parcel.has_method("get_parcel_type"):
		parcel_type = str(parcel.call("get_parcel_type"))
	if parcel.has_method("collect"):
		parcel.call("collect")
	player.update_carrying(true, parcel_type)
	var event_text := "Fragile parcel picked up" if parcel_type == PARCEL_TYPE_FRAGILE else "Parcel picked up"
	hud.show_event(event_text, PICKUP_EVENT_COLOR)
	_update_hud()


func _on_mailbox_delivery_requested() -> void:
	if state != GameState.PLAYING or not player.carrying_parcel:
		return

	deliveries += 1
	total_deliveries += 1
	player.update_carrying(false)
	hud.show_event("Delivered! %d to go" % max(0, TARGET_DELIVERIES - deliveries), DELIVERY_EVENT_COLOR)
	if deliveries >= TARGET_DELIVERIES:
		clear_floor()
	else:
		_spawn_next_parcel()
		_update_hud()


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
	var penalty := _normal_hazard_penalty()
	var event_text := "Hazard hit! -%d seconds" % int(penalty)
	if player.carrying_parcel:
		if player.carried_parcel_type == PARCEL_TYPE_FRAGILE:
			penalty = _fragile_hazard_penalty()
			event_text = "Fragile parcel broke! -%d seconds" % int(penalty)
		player.update_carrying(false)
		_spawn_next_parcel()
	time_left = max(0.0, time_left - penalty)
	hud.show_event(event_text, HAZARD_EVENT_COLOR)
	if time_left <= 0.0:
		end_run()
	else:
		_update_hud()


func clear_floor() -> void:
	state = GameState.FLOOR_CLEAR
	best_floor = max(best_floor, floor_number)
	pending_upgrade_options = _pick_upgrade_options()
	player.stop()
	_clear_children(parcels)
	_clear_children(hazards)
	_update_hud()
	hud.show_upgrade_choices(floor_number, floor_number + 1, pending_upgrade_options)


func end_run() -> void:
	state = GameState.LOST
	pending_upgrade_options.clear()
	best_floor = max(best_floor, floor_number)
	player.stop()
	_update_hud()
	hud.show_run_summary(floor_number, total_deliveries, _chosen_upgrade_summary())


func _pick_upgrade_options() -> Array[Dictionary]:
	var available_options: Array[Dictionary] = []
	for upgrade in UPGRADE_POOL:
		if _upgrade_stack_count(str(upgrade["id"])) < _upgrade_max_stacks(str(upgrade["id"])):
			available_options.append(upgrade)

	var options: Array[Dictionary] = []
	while options.size() < 3 and not available_options.is_empty():
		var index := rng.randi_range(0, available_options.size() - 1)
		options.append(available_options.pop_at(index))
	return options


func _choose_upgrade(index: int) -> void:
	if index < 0 or index >= pending_upgrade_options.size():
		return

	var upgrade := pending_upgrade_options[index]
	var upgrade_id := str(upgrade["id"])
	if _upgrade_stack_count(upgrade_id) >= _upgrade_max_stacks(upgrade_id):
		return

	chosen_upgrades.append(upgrade_id)
	hud.show_event("Chose %s" % str(upgrade["name"]), UPGRADE_EVENT_COLOR)
	pending_upgrade_options.clear()
	advance_floor()


func _chosen_upgrade_summary() -> Array[String]:
	var summary: Array[String] = []
	for upgrade in UPGRADE_POOL:
		var upgrade_id := str(upgrade["id"])
		var count := _upgrade_stack_count(upgrade_id)
		if count <= 0:
			continue
		var upgrade_name := str(upgrade["name"])
		summary.append("%s x%d" % [upgrade_name, count])
	return summary


func _upgrade_stack_count(upgrade_id: String) -> int:
	return chosen_upgrades.count(upgrade_id)


func _upgrade_max_stacks(upgrade_id: String) -> int:
	match upgrade_id:
		UPGRADE_BRIGHTER_WINGS:
			return BRIGHTER_WINGS_MAX_STACKS
		UPGRADE_MOONLIT_MINUTE:
			return MOONLIT_MINUTE_MAX_STACKS
		UPGRADE_GENTLE_HANDLING:
			return GENTLE_HANDLING_MAX_STACKS
		UPGRADE_LUCKY_SATCHEL:
			return LUCKY_SATCHEL_MAX_STACKS
		UPGRADE_WIDE_GLOW:
			return WIDE_GLOW_MAX_STACKS
		_:
			return 1


func _apply_upgrade_effects() -> void:
	var speed_bonus := _upgrade_stack_count(UPGRADE_BRIGHTER_WINGS) * BRIGHTER_WINGS_SPEED_BONUS
	player.set_speed_multiplier(1.0 + speed_bonus)
	var pickup_bonus := _upgrade_stack_count(UPGRADE_WIDE_GLOW) * WIDE_GLOW_RADIUS_BONUS
	player.set_pickup_radius_multiplier(1.0 + pickup_bonus)


func _normal_hazard_penalty() -> float:
	var reduction := _upgrade_stack_count(UPGRADE_LUCKY_SATCHEL) * LUCKY_SATCHEL_PENALTY_REDUCTION
	return max(0.0, HAZARD_PENALTY - reduction)


func _fragile_hazard_penalty() -> float:
	var reduction := _upgrade_stack_count(UPGRADE_GENTLE_HANDLING) * GENTLE_HANDLING_PENALTY_REDUCTION
	return max(0.0, FRAGILE_HAZARD_PENALTY - reduction)


func _update_hud() -> void:
	hud.update_status(
		floor_number,
		best_floor,
		deliveries,
		TARGET_DELIVERIES,
		total_deliveries,
		time_left,
		player.carrying_parcel
	)


func _unhandled_input(event: InputEvent) -> void:
	if state != GameState.FLOOR_CLEAR:
		return
	if not event is InputEventKey:
		return

	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	match key_event.keycode:
		KEY_1, KEY_KP_1:
			_choose_upgrade(0)
		KEY_2, KEY_KP_2:
			_choose_upgrade(1)
		KEY_3, KEY_KP_3:
			_choose_upgrade(2)


func _clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
