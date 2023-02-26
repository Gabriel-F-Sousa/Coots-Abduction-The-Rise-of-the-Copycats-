extends Node2D

@export var next_level :PackedScene


func _on_area_2d_body_entered(body):
	$AnimationPlayer.play("end")
	pass

func change_level():
	get_tree().change_scene_to_packed(next_level)
	CHECKPOINT.clear()
	pass
