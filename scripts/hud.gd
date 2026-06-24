extends CanvasLayer

@onready var floor_label: Label = $Root/FloorLabel
@onready var score_label: Label = $Root/ScoreLabel
@onready var timer_label: Label = $Root/TimerLabel
@onready var carry_label: Label = $Root/CarryLabel
@onready var event_label: Label = $Root/EventLabel
@onready var message_label: Label = $Root/MessageLabel

var event_time_left := 0.0


func _process(delta: float) -> void:
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


func show_upgrade_choices(floor_number: int, next_floor: int, options: Array[Dictionary]) -> void:
	var lines: Array[String] = [
		"Floor %d clear! Choose an upgrade for Floor %d:" % [floor_number, next_floor]
	]
	for index in range(options.size()):
		lines.append("%d. %s" % [index + 1, str(options[index]["name"])])
	lines.append("Press 1, 2, or 3. Press R to restart.")
	message_label.text = "\n".join(lines)


func clear_message() -> void:
	message_label.text = ""
	event_label.text = ""
	event_time_left = 0.0
	event_label.modulate.a = 0.0
