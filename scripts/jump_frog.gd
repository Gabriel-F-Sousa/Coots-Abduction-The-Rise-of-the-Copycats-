extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var JUMP_VELOCITY = -250.0
var SPEED = 100.0
var JUMP = true
var dir = -1
var dmg = 1
var hp = 1
var stunned = false

func _ready():
	pass

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = 0
	
	if stunned:
		$AnimatedSprite2D.modulate = Color(0.47843137383461, 0.47843137383461, 0.47843137383461)
	else:
		$AnimatedSprite2D.modulate = Color(1, 1, 1)
	
	if JUMP and !stunned:
		jump(delta)
	
	
	move_and_slide()
	pass

func jump(delta):
	$AudioStreamPlayer2D.play()
	if $wallCheck.is_colliding():
		dir *= -1
		animation_handler()
	
	velocity.y = JUMP_VELOCITY 
	velocity.x = SPEED * dir
	
	JUMP = false
	await get_tree().create_timer(1.5).timeout
	JUMP = true
	pass

func hurt(origin, dmg):
	$AnimatedSprite2D.material.set_shader_parameter("shine", true)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.material.set_shader_parameter("shine", false)
	hp -= dmg
	if hp <= 0:
		$AnimationPlayer.play("die")
	pass

func stun(origin, time):
	stunned = true
	velocity.x = 0
	velocity.y = 0
	$AnimationPlayer.play("stun")
	await get_tree().create_timer(time).timeout
	stunned = false
	pass


func animation_handler():
	if dir == 1:
		$AnimatedSprite2D.flip_h = true
		$wallCheck.target_position *= -1
	else:
		$AnimatedSprite2D.flip_h = false
		$wallCheck.target_position *= -1











