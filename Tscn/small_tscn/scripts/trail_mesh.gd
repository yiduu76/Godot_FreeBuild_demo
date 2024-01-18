extends MeshInstance2D

func _ready():
	pass

func _process(_delta):
	self.modulate.a-=0.005
	self.scale.x-=0.01
	self.scale.y-=0.01
	if modulate.a<=0:
		self.queue_free()
	pass
