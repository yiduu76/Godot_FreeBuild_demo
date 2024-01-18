extends GPUParticles2D

func _ready():
	$Timer.start(0)
	$AudioStreamPlayer2D.playing=true
	pass 

func _on_timer_timeout():
	self.queue_free()
