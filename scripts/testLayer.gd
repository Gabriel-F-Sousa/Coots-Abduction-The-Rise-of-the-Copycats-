extends CanvasLayer

#@onready var player = $".."
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $".."
	$VBoxContainer/speed.text = str("speed:{SPEED}").format({"SPEED" = player.SPEED})
	$VBoxContainer/speedSlider.value = player.SPEED #Wall Jump Speed:
	
	$VBoxContainer/WallJumpSpd.text = str("speed:{SPEED}").format({"SPEED" = player.wallJumpSpd})
	$VBoxContainer/WallJumpSpdSlider.value = player.wallJumpSpd

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_speed_slider_value_changed(value):
	player.SPEED = float(value)
	$VBoxContainer/speed.text = str("speed:{SPEED}").format({"SPEED" = player.SPEED})



func _wall_jump_spd_slider_value_changed(value):
	player.wallJumpSpd = float(value)
	$VBoxContainer/WallJumpSpd.text = str("speed:{SPEED}").format({"SPEED" = player.wallJumpSpd})
