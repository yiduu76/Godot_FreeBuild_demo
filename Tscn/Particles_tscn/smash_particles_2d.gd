extends GPUParticles2D

func _ready():
	$Timer.start(0)
	$AudioStreamPlayer2D.playing=true
	self.emitting=true
	$smash_particles_2d2.emitting=true
	pass 

func _on_timer_timeout():
	self.queue_free()
