extends CanvasLayer

@onready var score_label: Label = $Root/ScoreLabel
@onready var timer_label: Label = $Root/TimerLabel
@onready var carry_label: Label = $Root/CarryLabel
@onready var message_label: Label = $Root/MessageLabel


func update_status(deliveries: int, target_deliveries: int, time_left: float, carrying: bool) -> void:
	score_label.text = "Deliveries: %d / %d" % [deliveries, target_deliveries]
	timer_label.text = "Night: %02d" % max(0, ceili(time_left))
	carry_label.text = "Parcel: %s" % ("carried" if carrying else "none")


func show_message(message: String) -> void:
	message_label.text = message


func clear_message() -> void:
	message_label.text = ""
