extends Node2D

# warning-ignore:unused_class_variable
var _col_type = 3

var off = preload("res://cp.png")
var on = preload("res://cp2.png")

func reset():
	$Sprite.texture = off
	$Sprite2.texture = off

func turn_on():
	$Sprite.texture = on
	$Sprite2.texture = on
