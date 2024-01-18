extends GPUParticles2D

func _ready():
	$Timer.start(0)
	pass 

func _on_timer_timeout():
	self.queue_free()
