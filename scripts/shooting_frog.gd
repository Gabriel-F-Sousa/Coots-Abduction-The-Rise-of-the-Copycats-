extends CharacterBody2D

var TAD = preload("res://src/enemies/tad.tscn")
var can_shoot = true
var has_vision = null
var dmg = 1
var hp = 1

func _process(delta):
	if has_vision:
		if has_vision.position > self.position:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	if has_vision != null and can_shoot:
		call_deferred("shoot", has_vision)
	pass

func shoot(target):
	var pf = TAD.instantiate()
	
	pf.global_position = $tadSpawn.global_position
	pf.look_at(target.global_position)
	pf.point_direction = to_local(target.global_position)
	get_parent().add_child(pf)
	
	can_shoot = false
	await get_tree().create_timer(1.5).timeout
	can_shoot = true
	pass

func _detect_area_body_entered(body):
	has_vision = body
	pass

func _detect_area_body_exited(body):
	has_vision = null
	pass

func hurt(origin, dmg):
	$AnimatedSprite2D.material.set_shader_parameter("shine", true)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.material.set_shader_parameter("shine", false)
	hp -= dmg
	if hp <= 0:
		$AnimationPlayer.play("die")
	pass

