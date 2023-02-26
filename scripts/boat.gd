extends CharacterBody2D

var BALL = preload("res://src/friend_cannon_ball.tscn")
var direction = Vector2.ZERO
var SPEED = 100.0
var can_shoot = true
var hp = 3
var invinciblility = false

signal player_die


func _ready():
	pass

func _physics_process(delta):
	movement(delta)
	if Input.is_action_just_pressed("ui_accept") and can_shoot:
		shoot_dir(Vector2.DOWN)
	move_and_slide()
	pass

func movement(delta):
	direction.x = Input.get_axis("ui_down", "ui_up")
	direction.y = Input.get_axis("ui_left", "ui_right")
	
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = 0
	
	if direction.y:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = 0

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
	var pf = BALL.instantiate()
	pf.speed = 2
	pf.global_position = $projectileSpawn.global_position
	pf.point_direction = dir
	get_parent().add_child(pf)
	can_shoot = false
	await get_tree().create_timer(0.2).timeout
	can_shoot = true
	pass

func hurt(origin, dmg):
	print(self.name, origin, dmg)
	if invinciblility == false:
		$Sprite2D.material.set_shader_parameter("shine", true)
		await get_tree().create_timer(0.2).timeout
		$Sprite2D.material.set_shader_parameter("shine", false)
		hp -= dmg
		invinciblility = true
		$invinciblility.start(1)
	if hp <= 0:
		var tween = create_tween()
		tween.stop()
		set_physics_process(false)
		$AnimationPlayer.play("die")
		
	pass

func die():
	emit_signal("player_die")
	pass

func _invinciblility_timeout():
	invinciblility = false
	pass # Replace with function body.
