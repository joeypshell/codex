extends SceneTree

var failures := 0


func _initialize() -> void:
	var main = load("res://scripts/main.gd").new()

	_test_floor_time(main)
	_test_fragile_rules(main)
	_test_hazard_penalties(main)
	_test_upgrade_caps(main)
	_test_layout_selection(main)
	main.free()

	if failures > 0:
		printerr("%d rule test(s) failed." % failures)
		quit(1)
		return

	print("All rule tests passed.")
	quit(0)


func _test_floor_time(main: Node) -> void:
	main.floor_number = 1
	main.chosen_upgrades.clear()
	_assert_equal(main._floor_time(), 58.0, "Floor 1 uses scaled timer")

	main.floor_number = 20
	_assert_equal(main._floor_time(), 35.0, "Floor timer has minimum")

	main.floor_number = 5
	main.chosen_upgrades.append("moonlit_minute")
	main.chosen_upgrades.append("moonlit_minute")
	_assert_equal(main._floor_time(), 66.0, "Moonlit Minute adds future floor time")


func _test_fragile_rules(main: Node) -> void:
	main.floor_number = 1
	main.deliveries = 0
	_assert_equal(main._next_parcel_type(), "normal", "Floor 1 first parcel is normal")

	main.deliveries = 1
	_assert_equal(main._next_parcel_type(), "fragile", "Floor 1 delivery 1 spawns fragile")

	main.deliveries = 2
	_assert_equal(main._next_parcel_type(), "normal", "Floor 1 delivery 2 spawns normal")

	main.floor_number = 2
	_assert_equal(main._fragile_parcel_chance(), 0.41, "Floor 2 fragile chance matches formula")


func _test_hazard_penalties(main: Node) -> void:
	main.chosen_upgrades.clear()
	_assert_equal(main._normal_hazard_penalty(), 6.0, "Base normal hazard penalty")
	_assert_equal(main._fragile_hazard_penalty(), 12.0, "Base fragile hazard penalty")

	main.chosen_upgrades.append("lucky_satchel")
	main.chosen_upgrades.append("lucky_satchel")
	main.chosen_upgrades.append("gentle_handling")
	_assert_equal(main._normal_hazard_penalty(), 4.0, "Lucky Satchel reduces normal penalty")
	_assert_equal(main._fragile_hazard_penalty(), 10.0, "Gentle Handling reduces fragile penalty")


func _test_upgrade_caps(main: Node) -> void:
	_assert_equal(main._upgrade_max_stacks("brighter_wings"), 3, "Brighter Wings cap")
	_assert_equal(main._upgrade_max_stacks("moonlit_minute"), 3, "Moonlit Minute cap")
	_assert_equal(main._upgrade_max_stacks("gentle_handling"), 2, "Gentle Handling cap")
	_assert_equal(main._upgrade_max_stacks("lucky_satchel"), 2, "Lucky Satchel cap")
	_assert_equal(main._upgrade_max_stacks("wide_glow"), 2, "Wide Glow cap")


func _test_layout_selection(main: Node) -> void:
	main.rng.seed = 1234
	main.last_layout_id = ""
	main._choose_floor_layout()
	var first_layout := str(main.current_layout["id"])
	main._choose_floor_layout()
	var second_layout := str(main.current_layout["id"])

	_assert_true(first_layout in ["A", "B", "C"], "First layout is known")
	_assert_true(second_layout in ["A", "B", "C"], "Second layout is known")
	_assert_true(first_layout != second_layout, "Layouts avoid immediate repeats")


func _assert_equal(actual, expected, label: String) -> void:
	if actual is float or expected is float:
		_assert_float_equal(float(actual), float(expected), label)
		return

	if actual == expected:
		print("PASS: %s" % label)
		return

	failures += 1
	printerr("FAIL: %s: expected %s, got %s" % [label, str(expected), str(actual)])


func _assert_float_equal(actual: float, expected: float, label: String) -> void:
	if is_equal_approx(actual, expected):
		print("PASS: %s" % label)
		return

	failures += 1
	printerr("FAIL: %s: expected %s, got %s" % [label, str(expected), str(actual)])


func _assert_true(value: bool, label: String) -> void:
	if value:
		print("PASS: %s" % label)
		return

	failures += 1
	printerr("FAIL: %s" % label)
