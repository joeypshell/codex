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
@onready var touch_up_button: Button = $Root/MobileControls/UpButton
@onready var touch_down_button: Button = $Root/MobileControls/DownButton
@onready var touch_left_button: Button = $Root/MobileControls/LeftButton
@onready var touch_right_button: Button = $Root/MobileControls/RightButton
@onready var action_controls: Control = $Root/ActionControls
@onready var upgrade_buttons := [
	$Root/ActionControls/UpgradeButton1,
	$Root/ActionControls/UpgradeButton2,
	$Root/ActionControls/UpgradeButton3,
]
@onready var restart_button: Button = $Root/ActionControls/RestartButton

var event_time_left := 0.0
var held_touch_directions := {}


func _ready() -> void:
	_connect_touch_button(touch_up_button, Vector2.UP)
	_connect_touch_button(touch_down_button, Vector2.DOWN)
	_connect_touch_button(touch_left_button, Vector2.LEFT)
	_connect_touch_button(touch_right_button, Vector2.RIGHT)
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


func _connect_touch_button(button: Button, direction: Vector2) -> void:
	button.button_down.connect(_on_touch_button_down.bind(direction))
	button.button_up.connect(_on_touch_button_up.bind(direction))


func _on_touch_button_down(direction: Vector2) -> void:
	held_touch_directions[direction] = true
	touch_start_requested.emit()
	_emit_touch_direction()


func _on_touch_button_up(direction: Vector2) -> void:
	held_touch_directions.erase(direction)
	_emit_touch_direction()


func _emit_touch_direction() -> void:
	var direction := Vector2.ZERO
	for held_direction in held_touch_directions.keys():
		direction += held_direction as Vector2
	touch_movement_changed.emit(direction.normalized() if direction != Vector2.ZERO else Vector2.ZERO)


func _on_upgrade_button_pressed(index: int) -> void:
	touch_upgrade_selected.emit(index)


func _on_restart_button_pressed() -> void:
	touch_restart_requested.emit()


func _update_mobile_controls_visibility() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	mobile_controls.visible = (
		DisplayServer.is_touchscreen_available()
		or OS.has_feature("web_android")
		or OS.has_feature("web_ios")
		or viewport_size.x < 760.0
	)
