extends CanvasLayer

signal touch_movement_changed(direction: Vector2)
signal touch_start_requested
signal touch_upgrade_selected(index: int)
signal touch_restart_requested

@onready var floor_label: Label = $Root/FloorLabel
@onready var score_label: Label = $Root/ScoreLabel
@onready var timer_label: Label = $Root/TimerLabel
@onready var carry_label: Label = $Root/CarryLabel
@onready var event_label: Label = $Root/EventLabel
@onready var message_label: Label = $Root/MessageLabel
@onready var mobile_controls: Control = $Root/MobileControls
@onready var action_controls: Control = $Root/ActionControls
@onready var upgrade_buttons := [
	$Root/ActionControls/UpgradeButton1,
	$Root/ActionControls/UpgradeButton2,
	$Root/ActionControls/UpgradeButton3,
]
@onready var restart_button: Button = $Root/ActionControls/RestartButton

const TOUCH_DEADZONE := 14.0

var event_time_left := 0.0
var movement_touch_index := -1
var movement_touch_start := Vector2.ZERO


func _ready() -> void:
	for index in range(upgrade_buttons.size()):
		var button: Button = upgrade_buttons[index]
		button.pressed.connect(_on_upgrade_button_pressed.bind(index))
	restart_button.pressed.connect(_on_restart_button_pressed)
	hide_action_controls()
	_update_mobile_controls_visibility()


func _process(delta: float) -> void:
	_update_mobile_controls_visibility()
	if event_time_left <= 0.0:
		event_label.modulate.a = 0.0
		return

	event_time_left = max(0.0, event_time_left - delta)
	event_label.modulate.a = min(1.0, event_time_left * 2.0)


func _input(event: InputEvent) -> void:
	if not _mobile_controls_enabled():
		return

	if event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		if touch_event.pressed:
			if movement_touch_index == -1 and not _is_touch_on_action_controls(touch_event.position):
				movement_touch_index = touch_event.index
				movement_touch_start = touch_event.position
				touch_start_requested.emit()
				touch_movement_changed.emit(Vector2.ZERO)
				get_viewport().set_input_as_handled()
		elif touch_event.index == movement_touch_index:
			movement_touch_index = -1
			touch_movement_changed.emit(Vector2.ZERO)
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		var drag_event := event as InputEventScreenDrag
		if drag_event.index == movement_touch_index:
			touch_movement_changed.emit(_drag_direction(drag_event.position))
			get_viewport().set_input_as_handled()


func update_status(
	floor_number: int,
	best_floor: int,
	deliveries: int,
	target_deliveries: int,
	total_deliveries: int,
	time_left: float,
	carrying: bool
) -> void:
	floor_label.text = "Floor: %d  Best: %d" % [floor_number, best_floor]
	score_label.text = "Deliveries: %d / %d  Total: %d" % [deliveries, target_deliveries, total_deliveries]
	timer_label.text = "Night: %02d" % max(0, ceili(time_left))
	carry_label.text = "Parcel: %s" % ("carried" if carrying else "none")


func show_event(message: String, color: Color) -> void:
	event_label.text = message
	event_label.modulate = color
	event_label.modulate.a = 1.0
	event_time_left = 1.5


func show_message(message: String) -> void:
	message_label.text = message
	hide_action_controls()


func show_upgrade_choices(floor_number: int, next_floor: int, options: Array[Dictionary]) -> void:
	var lines: Array[String] = [
		"Floor %d clear!" % floor_number,
		"Choose an upgrade for Floor %d:" % next_floor,
	]
	for index in range(options.size()):
		lines.append("%d. %s" % [index + 1, str(options[index]["name"])])
	lines.append("Press 1, 2, or 3, or tap an upgrade.")
	message_label.text = "\n".join(lines)
	action_controls.visible = true
	restart_button.visible = false
	for index in range(upgrade_buttons.size()):
		var button: Button = upgrade_buttons[index]
		if index < options.size():
			button.text = "%d. %s" % [index + 1, str(options[index]["name"])]
			button.visible = true
			button.disabled = false
		else:
			button.visible = false
			button.disabled = true


func show_run_summary(floor_number: int, total_deliveries: int, upgrades: Array[String]) -> void:
	var lines: Array[String] = [
		"Run ended",
		"Floor reached: %d" % floor_number,
		"Total deliveries: %d" % total_deliveries,
	]
	if upgrades.is_empty():
		lines.append("Upgrades: none")
	else:
		lines.append("Upgrades:")
		lines.append(", ".join(upgrades))
	lines.append("Press R or tap Restart.")
	message_label.text = "\n".join(lines)
	action_controls.visible = true
	for button in upgrade_buttons:
		button.visible = false
		button.disabled = true
	restart_button.visible = true


func clear_message() -> void:
	message_label.text = ""
	event_label.text = ""
	event_time_left = 0.0
	event_label.modulate.a = 0.0
	hide_action_controls()


func hide_action_controls() -> void:
	action_controls.visible = false
	for button in upgrade_buttons:
		button.visible = false
		button.disabled = true
	restart_button.visible = false


func _on_upgrade_button_pressed(index: int) -> void:
	touch_upgrade_selected.emit(index)


func _on_restart_button_pressed() -> void:
	touch_restart_requested.emit()


func _update_mobile_controls_visibility() -> void:
	mobile_controls.visible = _mobile_controls_enabled()


func _mobile_controls_enabled() -> bool:
	var viewport_size := get_viewport().get_visible_rect().size
	return (
		DisplayServer.is_touchscreen_available()
		or OS.has_feature("web_android")
		or OS.has_feature("web_ios")
		or viewport_size.x < 760.0
	)


func _is_touch_on_action_controls(position: Vector2) -> bool:
	return action_controls.visible and action_controls.get_global_rect().has_point(position)


func _drag_direction(position: Vector2) -> Vector2:
	var offset := position - movement_touch_start
	if offset.length() < TOUCH_DEADZONE:
		return Vector2.ZERO
	return offset.normalized()
