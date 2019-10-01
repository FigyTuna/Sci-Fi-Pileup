extends Node2D

var gas_on = false
var breaks_on = false
var left_on = false
var right_on = false

var velocity = 0
var acc = 10
var drag = 5
var max_speed = 25

var off_road = true
var off_road_drag = 35
var off_road_max_speed = 5
var road_count = 0

var rot = 0
var rot_acc = .3
var rot_drag = 1.2

var cp = 0

signal pass_cp(car, current, passed)

var crash_sfx = []

# warning-ignore:unused_class_variable
var _col_type = 1

func _ready():
# warning-ignore:return_value_discarded
	$Controller.connect("gas", self, "gas")
# warning-ignore:return_value_discarded
	$Controller.connect("breaks", self, "breaks")
# warning-ignore:return_value_discarded
	$Controller.connect("left", self, "left")
# warning-ignore:return_value_discarded
	$Controller.connect("right", self, "right")
	
	crash_sfx.append($Area2D/c1)
	crash_sfx.append($Area2D/c2)
	crash_sfx.append($Area2D/c3)
	crash_sfx.append($Area2D/c4)

func _physics_process(delta):
	
	if gas_on:
		velocity += acc * delta
	
	if breaks_on:
		velocity /= 1.01
	
	if left_on:
		rot -= rot_acc * delta
	if right_on:
		rot += rot_acc * delta
	
	if off_road and velocity >= off_road_max_speed:
		velocity -= off_road_drag * delta
	else:
		velocity -= drag * delta
	
	if velocity < 4:
		rot *= (velocity / 4)
	
	rot /= rot_drag
	
	if velocity > max_speed:
		velocity = max_speed
	elif velocity < 0:
		velocity = 0
	
	position.y -= cos(rotation) * velocity
	position.x += sin(rotation) * velocity
	
	rotation += rot
	
	gas_on = false
	breaks_on = false
	left_on = false
	right_on = false

func gas():
	gas_on = true

func breaks():
	breaks_on = true

func left():
	left_on = true

func right():
	right_on = true

func update_cp(new_cp):
	cp = new_cp

func _on_Area2D_area_entered(area):
	var ob = area.get_parent()
	if ob._col_type == 1:
		position += (position - ob.position) * .3
		velocity /= 1.5
		crash_sfx[randi() % 4].play()
	elif ob._col_type == 2:
		road_count += 1
		off_road = false
	elif ob._col_type == 3:
		emit_signal("pass_cp", self, cp, ob)

func _on_Area2D_area_exited(area):
	if area.get_parent()._col_type == 2:
		road_count -= 1
		if road_count < 1:
			off_road = true
