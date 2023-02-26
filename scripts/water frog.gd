extends CharacterBody2D

var dmg = 1
@export var hp :int = 1
var dead = false

func _ready():
	randomize()
	await get_tree().create_timer(randf_range(0.5,2)).timeout
	$AnimationPlayer.play("attack")
	pass

func _process(delta):
	pass

func extend_tongue():
	var tween = get_tree().create_tween()
	tween.tween_method(move_tongue, $tongue.points[1], $tongueEnd.position, 0.2).set_ease(Tween.EASE_OUT)

func down_tongue():
	var tween = get_tree().create_tween()
	tween.tween_method(move_tongue, $tongue.points[1], Vector2(0,5), 0.2).set_ease(Tween.EASE_OUT)
	pass

func move_tongue(value):
	$tongue.points[1] = value
	$TongueEndSprite.position = $tongue.points[1]
	$hurtbox/CollisionShape2D.get_shape().b = $TongueEndSprite.position + Vector2(0,-8 + -2)
	pass

func start_retract():
	$AnimationPlayer.play("idle")

func start_attack():
	await get_tree().create_timer(randf_range(0, 0.5)).timeout
	$AnimationPlayer.play("attack")

func hurt(origin, dmg):
	$AnimatedSprite2D.material.set_shader_parameter("shine", true)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.material.set_shader_parameter("shine", false)
	hp -= dmg
	if hp <= 0:
		$AnimationPlayer.play("die")
	pass

func stun(origin, dmg):
	
	pass















