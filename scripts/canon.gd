extends CharacterBody2D

var BALL = preload("res://src/enemies/cannon_ball.tscn")
var can_shoot = true
var has_vision = null
var dmg = 1
var hp = 1

@export var dir :Vector2 = Vector2.LEFT

func _ready():
	pass

func _process(delta):
	if $RayCast2D.is_colliding():
		shoot_dir(dir)
		$RayCast2D.enabled = false
	pass

func shoot(target):
	var pf = BALL.instantiate()
	
	pf.global_position = $projectileSpawn.global_position
	pf.look_at(target.global_position)
	pf.point_direction = to_local(target.global_position)
	get_parent().add_child(pf)
	
	can_shoot = false
	await get_tree().create_timer(1.5).timeout
	can_shoot = true
	emit_signal("action_done")
	pass

func shoot_dir(dir:Vector2):
	$AudioStreamPlayer2D.play()
	var pf = BALL.instantiate()
	pf.speed = 2
	pf.global_position = $projectileSpawn.global_position
	pf.point_direction = dir
	get_parent().add_child(pf)
	$shootingCD.start(2)
	pass

func _shooting_cd_timeout():
	shoot_dir(dir)
	pass
