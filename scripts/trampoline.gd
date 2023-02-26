extends StaticBody2D

@export var boost = 500


func _ready():
	pass



func _process(delta):
	pass


func _trampoline_bounce_body_entered(body):
	$AudioStreamPlayer2D.play()
	body.velocity.y -= boost 
	pass
