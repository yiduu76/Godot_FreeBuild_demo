extends GPUParticles2D
var parent_node:EnemyClass
@export var particles_force_scale=1.0
@export var MAX_amount=21
func _ready():
	parent_node=self.get_parent()

func _process(_delta):
	emit_par()

func emit_par():
	MAX_amount=parent_node.speed
	var force_dir:Vector2=($Marker2D1.global_position-$Marker2D2.global_position).normalized()
	self.amount=int(MAX_amount)+1
	self.emitting=true
#	parent_node.apply_central_force(force_dir*(amount-1)*particles_force_scale)
	parent_node.export_force=force_dir*(amount-1)*particles_force_scale*parent_node.mass
