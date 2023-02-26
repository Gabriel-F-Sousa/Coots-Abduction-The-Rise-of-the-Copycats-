extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false
var hp = 3
var dmg = 1
var TAD = preload("res://src/enemies/tad.tscn")
var can_shoot = true
var invinciblility = false

signal done_jumping
signal action_done
signal frog_cat_dead


func _ready():
	pass

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = 0
		if jumping:
			jumping = false
			$jumpCD.start(1)
	
	move_and_slide()

func extend_tongue():
	$extendSFX.play()
	var tween = get_tree().create_tween()
	tween.tween_method(move_tongue, $tongue.points[1], $tongueEnd.position, 0.5).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("retract")
	await $AnimationPlayer.animation_finished
	emit_signal("action_done")

func down_tongue():
	var tween = get_tree().create_tween()
	tween.tween_method(move_tongue, $tongue.points[1], $tongue.points[0], 0.3).set_ease(Tween.EASE_OUT)
	pass

func move_tongue(value):
	
	$tongue.points[1] = value
	$TongueEndSprite.position = $tongue.points[1] + $tongue.position
	$hurtbox/CollisionShape2D.get_shape().b = $TongueEndSprite.position #+ Vector2(0,-8 + -2)
	$TongueEndSprite.rotation = deg_to_rad(-90)
	pass

func jump_to(POS):
	$AudioStreamPlayer2D.play()
	jumping = true
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(POS.x, POS.y - 50), 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
#	await tween.step_finished
#	jumping = false
	
	pass

func jump_to_player(POS):
	$jumpSFX.play()
	var jump_direction = (self.position - POS)
	jump_direction.y -= 100 # Adding -30 to Y direction (UP)
	jump_direction.y = clamp(jump_direction.y, -100, 0) # Max JumpForce is -60
	velocity = jump_direction
	move_and_slide()

func shoot(target):
	var pf = TAD.instantiate()
	
	pf.global_position = $tadSpawn.global_position
	pf.look_at(target.global_position)
	pf.point_direction = to_local(target.global_position)
	get_parent().add_child(pf)
	
	can_shoot = false
	await get_tree().create_timer(0.7).timeout
	can_shoot = true
	emit_signal("action_done")
	pass

func hurt(origin, dmg):
	printt(origin, dmg)
	if hp > 0:
		if invinciblility == false:
			$AnimatedSprite2D.material.set_shader_parameter("shine", true)
			await get_tree().create_timer(0.2).timeout
			$AnimatedSprite2D.material.set_shader_parameter("shine", false)
			hp -= dmg
			invinciblility = true
			$invinciblility.start(1)
	if hp <= 0:
		var tween = create_tween()
		tween.stop()
		$AnimationPlayer.play("die")
		emit_signal("frog_cat_dead")
	pass

func _jump_cd_timeout():
	emit_signal("action_done")
	pass

func _invinciblility_timeout():
	invinciblility = false
	pass # Replace with function body.
