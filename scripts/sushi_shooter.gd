extends CharacterBody2D

var BALL = preload("res://src/enemies/cannon_ball.tscn")
var can_shoot = true
var has_vision = null
var dmg = 1
var hp = 1

@export var dir :Vector2 = Vector2.LEFT
@export var shooting_CD :int = 0.5

func _process(delta):
	if $RayCast2D.is_colliding():
		shoot_dir(dir)
		$RayCast2D.enabled = false
	pass

func shoot_dir(dir:Vector2):
	var pf = BALL.instantiate()
	pf.get_node("Sprite2D").texture = $ball.texture
	pf.speed = 1
	pf.global_position = $projectileSpawn.global_position
	pf.point_direction = dir
	get_parent().add_child(pf)
	$shootingCD.start(shooting_CD)
	pass

func hurt(origin, dmg):
	if hp > 0:
		$AnimatedSprite2D.material.set_shader_parameter("shine", true)
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.material.set_shader_parameter("shine", false)
		hp -= dmg
	if hp <= 0:
		set_process(false)
		$shootingCD.stop()
		$AnimationPlayer.play("die")
	pass

func _shooting_cd_timeout():
	shoot_dir(dir)
	pass




