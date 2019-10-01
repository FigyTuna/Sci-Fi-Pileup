extends Node2D

signal gas()
signal breaks()
signal left()
signal right()

var gas_on = false
var breaks_on = false
var left_on = false
var right_on = false

func _input(event):
	if event.is_action_pressed("gas"):
		emit_signal("gas")
		gas_on = true
	elif event.is_action_released("gas"):
		gas_on = false
	if event.is_action_pressed("breaks"):
		emit_signal("breaks")
		breaks_on = true
	elif event.is_action_released("breaks"):
		breaks_on = false
	if event.is_action_pressed("left"):
		emit_signal("left")
		left_on = true
	elif event.is_action_released("left"):
		left_on = false
	if event.is_action_pressed("right"):
		emit_signal("right")
		right_on = true
	elif event.is_action_released("right"):
		right_on = false
	if event.is_action_pressed("hard"):
		get_parent().get_parent().hard()

# warning-ignore:unused_argument
func _physics_process(delta):
	if gas_on:
		emit_signal("gas")
	if breaks_on:
		emit_signal("breaks")
	if left_on:
		emit_signal("left")
	if right_on:
		emit_signal("right")