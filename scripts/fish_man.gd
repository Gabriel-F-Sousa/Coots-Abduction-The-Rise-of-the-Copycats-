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
	randomize()
	$AnimatedSprite2D.play(str(randi_range(1,2)))
	pass

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !stunned:
		walk()
	
	if stunned:
		$AnimatedSprite2D.modulate = Color(0.47843137383461, 0.47843137383461, 0.47843137383461)
	else:
		$AnimatedSprite2D.modulate = Color(1, 1, 1)
	
	move_and_slide()

func walk():
	if is_on_wall():
		dir *= -1
		if dir == -1:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.position.x = -7
			$hurtbox/CollisionShape2D4.position.x = -12
			pass
		
		if dir == 1:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.position.x = 10
			$hurtbox/CollisionShape2D4.position.x = 15
			pass
	
	velocity.x = SPEED * dir
	
	pass

func hurt(origin, dmg):
	printt(self, origin, dmg)
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

