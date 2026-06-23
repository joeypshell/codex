extends Area2D

signal delivery_requested


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("update_carrying") and body.carrying_parcel:
		delivery_requested.emit()
