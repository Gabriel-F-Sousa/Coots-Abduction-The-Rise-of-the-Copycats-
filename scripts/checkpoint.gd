extends Node

var current_checkpoint = null

var checkpoints_passed = []

func _ready():
	pass


func setup_checkpoints():
	for i in checkpoints_passed:
		get_node(i).passed = true
		get_node(i).get_node("checkpoint").set_deferred("monitoring", false)
	pass

func clear():
	checkpoints_passed.clear()
	current_checkpoint = null







