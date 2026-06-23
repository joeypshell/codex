extends Area2D

var collected := false


func _ready() -> void:
	add_to_group("parcels")


func collect() -> void:
	if collected:
		return
	collected = true
	queue_free()
