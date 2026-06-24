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


func clear_message() -> void:
	message_label.text = ""
	event_label.text = ""
	event_time_left = 0.0
	event_label.modulate.a = 0.0
