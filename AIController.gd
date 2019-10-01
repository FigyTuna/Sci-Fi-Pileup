extends Node2D

signal gas()
# warning-ignore:unused_signal
signal breaks()
signal left()
signal right()

var img = preload("res://car2.png")
var car

export (NodePath)var next_cp_path
var next_cp

func _ready():
	get_parent().get_child(0).texture = img
	next_cp = get_node(next_cp_path)
	car = get_parent()

# warning-ignore:unused_argument
func _physics_process(delta):
	if car.velocity < 20:
		emit_signal("gas")
	var rot = int(car.rotation_degrees + (360 * 100) - 90) % 360 - 180
	var angle_to = rad2deg(car.global_position.angle_to_point(next_cp.global_position))
	var dir = rot - angle_to
	if (dir > 4 and dir < 180) or dir < -180:
		emit_signal("left")
	elif (dir < -4 and dir > -180) or dir > 180:
		emit_signal("right")