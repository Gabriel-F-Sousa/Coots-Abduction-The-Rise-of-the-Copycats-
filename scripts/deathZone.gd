extends Area2D



func _ready():
	pass



func _process(delta):
	pass


func _body_entered(body):
	if body.has_method("hurt"):
		body.hurt(self, 1000)
		
	pass
