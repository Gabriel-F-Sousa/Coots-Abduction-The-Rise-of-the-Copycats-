extends Node2D

var speed = 1.0
var point_direction = Vector2.ZERO
var dmg = 1


func _ready():
	pass


func _process(delta):
	global_position += point_direction.normalized() * speed
	pass


func _visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
