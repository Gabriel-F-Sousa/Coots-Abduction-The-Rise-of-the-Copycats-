extends CharacterBody2D

const jump_sfx = preload("res://assets/sfx/newjump.wav")

var SPEED = 100.0
var wallJumpSpd = 105.0
var JUMP_VELOCITY = -300.0
var hp = 3

@export_flags("double_jump") var double_jump_unlocked
@export_flags("gun") var gun_unlocked

var BALL = preload("res://src/friend_cannon_ball.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var playerDir = 1
var crouch = false
var wallJumping = false
var wallJumpDir = 1
var can_attack = true
var can_double_jump = true
var invinciblility = false
var shooting = false
var can_shoot = true

signal player_die


func _ready():
	$player_sfx.set("stream", jump_sfx)

func _physics_process(delta):
	shoot()
	movement(delta)
	animation_handler()
	attack()
	move_and_slide()

func movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		can_double_jump = true
		wallJumping = false
		wallJumpDir = 0
	
	#jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_stand() and !crouch:
		velocity.y = JUMP_VELOCITY 
		if $player_sfx.playing == false:
			$player_sfx.playing = true
		
	#release jump for a lower jump
	if Input.is_action_just_released("ui_accept") and velocity.y < 0 and !crouch:
		velocity.y = 0
		$player_sfx.playing = false
		pass
	
	#DOUBLE JUMP
	if !is_on_floor() and Input.is_action_just_pressed("ui_accept") and can_double_jump and double_jump_unlocked:
		can_double_jump = false
		velocity.y = JUMP_VELOCITY 
		if $player_sfx.playing == false:
			$player_sfx.playing = true
	
	
	#wall jump
	if can_wallJump():
		if Input.is_action_just_pressed("ui_accept") and !crouch:
			if $player_sfx.playing == false:
				$player_sfx.playing = true
			wallJumping = true
			wallJumpDir = playerDir
			playerDir *= -1
#			printt(playerDir, wallJumpDir, wallJumpSpd * wallJumpDir)
			velocity.y = JUMP_VELOCITY * 1
			velocity.x = move_toward(velocity.x, velocity.x + 200, wallJumpSpd * playerDir)
			$wallJumpTimer.start(0.3)
	
	#left/right movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if wallJumpDir == direction and wallJumping:
			pass
		else:
			if Input.is_action_pressed("run"):
				velocity.x = direction * (SPEED + SPEED * 0.5)
			else:
				velocity.x = direction * SPEED
			playerDir = direction
		
	else:
		#stops falling if walljumping
		if wallJumping:
			pass
		
		#keep the jump arc from wall jump
		elif not is_on_floor() and not direction and wallJumpDir != 0:
			velocity.x = move_toward(velocity.x, 0, 0.5)
		
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#crouch
	if Input.is_action_pressed("ui_down") and is_on_floor():
		crouch = true
		$standCol.disabled = true
		$crouchCol.disabled = false
	else:
		if can_stand():
			crouch = false
			$standCol.disabled = false
			$crouchCol.disabled = true
	if crouch:
		velocity.x = velocity.x * 0.3
	
	if crouch and Input.is_action_just_pressed("ui_accept"):
		self.position = Vector2(self.position.x, self.position.y + 1)

func shoot():
	if !crouch and Input.is_action_just_pressed("ui_focus_next") and can_shoot and gun_unlocked:
		$shoot.play()
		shooting = true
		can_shoot = false
		var pf = BALL.instantiate()
		pf.speed = 2
		pf.get_node("Sprite2D").texture = $bulletSprt.texture
		pf.global_position = $projectivePos.global_position
		pf.point_direction = Vector2(playerDir,0)
		get_parent().add_child(pf)
		$canShoot.start(0.1)
		await get_tree().create_timer(0.2).timeout
		shooting = false
		
	
	pass

func attack():
	if Input.is_action_just_pressed("ui_up") and can_attack:
		$BOYS.play()
		$boysAttack.monitoring = true
		$attackSprite.show()
		can_attack = false
		await get_tree().create_timer(0.2).timeout
		$boysAttack.monitoring = false
		$attackSprite.hide()
		$attackTimer.start(1)

func animation_handler():
	if shooting:
		$AnimatedSprite2D.play("shoot")
	
	if crouch and velocity.x == 0 and !shooting:
		$AnimatedSprite2D.set("animation", "crouch")
		
	
	elif crouch and (velocity.x > 0 or velocity.x < 0):
		$AnimatedSprite2D.set("animation", "crouch_walk")
	
	
	elif velocity.x == 0 and velocity.y == 0 and !shooting:
		$AnimatedSprite2D.set("animation", "idle")
	
	elif velocity.y < 0 and !shooting:
		$AnimatedSprite2D.set("animation", "jump")
		
		#$AnimationPlayer.play("jump")
	elif velocity.y > 0 and !shooting:
		$AnimatedSprite2D.set("animation", "fall")

	elif (velocity.x > 0 or velocity.x < 0) and is_on_floor() and !shooting:
		$AnimatedSprite2D.set("animation", "walk")
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$boysAttack.scale = Vector2(-1,-1)
		$attackSprite.position = Vector2(-20,0)
		$wallRay.target_position = Vector2(-7,0)
#		$attackSprite.scale = Vector2(-1,-1)#TESTING
		$attackSprite.play("left")
		$projectivePos.position.x = -12
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$boysAttack.scale = Vector2(1,1)
		$attackSprite.position = Vector2(20,0)
		$wallRay.target_position = Vector2(7,0)
#		$attackSprite.scale = Vector2(1,1)#TESTING
		$attackSprite.play("right")
		$projectivePos.position.x = 12

#checks if can stand
func can_stand():
	for i in $standRays.get_children():
		if i.is_colliding():
			return false
	return true

func can_wallJump():
#	if $wallRay.is_colliding() and !is_on_floor():
	if is_on_wall() and !is_on_floor():
		return true

func bounce():
	velocity.y = -300
	pass

func hurt(origin, dmg):
	if invinciblility == false:
		printt("got hurt", origin, dmg)
		$AnimatedSprite2D.material.set_shader_parameter("shine", true)
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.material.set_shader_parameter("shine", false)
		hp -= dmg
		invinciblility = true
		$invinciblility.start(0.5)
	
	if hp <= 0 or dmg >= 100:
		emit_signal("player_die")
	pass

func die():
	
	pass

func _wall_jump_timer_timeout():
	wallJumping = false

func _attack_timer_timeout():
	can_attack = true

func _boys_attack_body_entered(body):
	if body.has_method("stun"):
		body.stun(self, 1)
		pass
	
	pass


func _invinciblility_timeout():
	invinciblility = false
	pass

func _can_shoot_timeout():
	can_shoot = true
	pass




