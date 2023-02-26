extends Area2D

func _ready():
	self.area_entered.connect(AREA_ENTERED)
	pass


func AREA_ENTERED(area):
	if get_parent().has_method("hurt"):
		get_parent().hurt(area.get_parent(), 1)
	if area.get_parent().has_method("hurt"):
		area.get_parent().bounce()
	
	pass

