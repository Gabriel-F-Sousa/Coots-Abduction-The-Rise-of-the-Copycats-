extends CharacterBody2D

var hp = 6
var dmg = 1
var projectile = preload("res://src/enemies/cannon_ball.tscn")
var can_shoot = true
var invinciblility = false
var invulnarable = false
var phase = 1
var phase_2 = false
@onready var player = $"../../lud"
var last_action = null

signal action_done(action)

func _ready():
	action_done.connect(next_action)
	randomize()
	phase_one_movement(1)
	last_action = "phase_one_movement"
#	shoot(player)

func shoot_stars():
	for i in range(0,8):
		var pf = projectile.instantiate()
		pf.get_node("Sprite2D").texture = $star.texture
		pf.is_rotating = true
		pf.speed = 2
		pf.point_direction = Vector2(cos(deg_to_rad(45*i)), sin(deg_to_rad(45*i)))
		pf.global_position = self.global_position
		get_parent().call_deferred("add_child", pf)
		
	
	
	emit_signal("action_done", "shoot_stars")
	pass

func shoot(target):
	var pf = projectile.instantiate()
	pf.get_node("Sprite2D").texture = $star.texture
	pf.is_rotating = true
	pf.speed = 2
	
	pf.global_position = self.global_position
	pf.point_direction = target.global_position - pf.global_position
	
	get_parent().call_deferred("add_child", pf)
	
	emit_signal("action_done", "shoot")
	pass

func knife_throw():
	for i in range(0, 5):
		var DEG = -15
		var pf = projectile.instantiate()
		pf.get_node("Sprite2D").texture = $sword.texture
	#	pf.is_rotating = true
		pf.speed = 2
		pf.look_at(Vector2(cos(deg_to_rad(DEG*i)), sin(deg_to_rad(DEG*i))))
		pf.get_node("Sprite2D").flip_h = true
		pf.point_direction = Vector2(cos(deg_to_rad(DEG*i)), sin(deg_to_rad(DEG*i)))
		pf.global_position = self.global_position
		add_child(pf)
	
	emit_signal("action_done", "knife_throw")
	pass

func phase_one_movement(speed):
	#x_pos = 2112 2392
	var tween = get_tree().create_tween()
	Vector2(randi_range(2112, 2392),216)
	tween.tween_property(self, "global_position", Vector2(randi_range(2112, 2392), 184), speed)
	
	emit_signal("action_done", "phase_one_movement")
	pass

func start_phase_2():
	invulnarable = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(2416, 232), 2)
	await get_tree().create_timer(3).timeout
	invulnarable = false
	emit_signal("action_done", start_phase_2)
	pass

var im_out_of_time = false
func next_action(last_action):
#	printt(last_action)
	if hp <= 3:
		phase = 2
		if phase_2 == false:
			invulnarable = true
			start_phase_2()
			phase_2 = true
	
	if phase == 1:
		if last_action != "shoot_stars":
			await get_tree().create_timer(1).timeout
			shoot_stars()
			pass
		
		if last_action == "shoot_stars":
			phase_one_movement(1)
	
	if phase == 2 and !im_out_of_time:
		im_out_of_time = true
		var pattern = ["bot", "top", "mid"]
		phase_2_attack(pattern[randi_range(0,2)])
		
	pass

func hurt(origin, dmg):
	if invulnarable:
		return
	if (invinciblility != true and hp > 0):
		invinciblility = true
		$AnimatedSprite2D.material.set_shader_parameter("shine", true)
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.material.set_shader_parameter("shine", false)
		hp -= dmg
		$invinciblilityCD.start(0.5)
	if hp <= 0:
		$invinciblilityCD.stop()
		$phase2CD.stop()
		$AnimationPlayer.play("die")
		print("DIE")
	pass

func phase_2_attack(spot):
	var temp = null
	var bot = [$"../spawn/Marker2D2", $"../spawn/Marker2D3", $"../spawn/Marker2D4"]
	var mid = [$"../spawn/Marker2D5", $"../spawn/Marker2D6", $"../spawn/Marker2D7", $"../spawn/Marker2D8", $"../spawn/Marker2D9"]
	var top = [$"../spawn/Marker2D10", $"../spawn/Marker2D11", $"../spawn/Marker2D12", $"../spawn/Marker2D13"]
	
	if spot == "bot":
		temp = bot
	if spot == "mid":
		temp = mid
	if spot == "top":
		temp = top
	
	for i in temp:
		var pf = projectile.instantiate()
		pf.get_node("Sprite2D").texture = $sword.texture
#		pf.is_rotating = true
		pf.speed = 2
		pf.global_position = i.global_position
		pf.point_direction = Vector2.LEFT
		
		get_parent().call_deferred("add_child", pf)
	
	$phase2CD.start(1.5)
#	emit_signal("action_done", "phase_2_attack")
	pass

func _invinciblility_cd_timeout():
	invinciblility = false
	pass

func _phase_2cd_timeout():
	var pattern = ["bot", "top", "mid"]
	call_deferred("phase_2_attack", pattern[randi_range(0,2)])
#	phase_2_attack(pattern[randi_range(0,2)])
	
	pass











