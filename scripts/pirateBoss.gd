extends Node2D



func _ready():
	pass


func _process(delta):
	pass


func _start_boss_body_entered(body):
	if body.name == "lud":
		$startBoss.set_deferred("monitoring", false)
		$AnimationPlayer.play("start boss")
	pass
