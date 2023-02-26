extends AnimatableBody2D

var passed = false




func _checkpoint_body_entered(body):
	$AudioStreamPlayer2D.play()
	$checkpoint.set_deferred("monitoring", false)
	passed = true
	
	$AnimatedSprite2D.play("up")
	if !self.get_path() in CHECKPOINT.checkpoints_passed:
		CHECKPOINT.checkpoints_passed.append(self.get_path())
		CHECKPOINT.current_checkpoint = self.get_path()
		
	pass
