extends GPUParticles2D
var parent_node
@onready var export_force=Vector2.ZERO
@onready var particles_force_scale=28.0
@export var MAX_amount=21
func _ready():
	parent_node=self.get_parent()

func _process(_delta):
	if self.get_parent().Father_node==Glo.player:
		emit_par()
	else :
		pass
func emit_par():
	var force_dir:Vector2=($Marker2D1.global_position-$Marker2D2.global_position).normalized()
	if Glo.input_vec!=Vector2.ZERO:
		var temp_angel=force_dir.angle_to(Glo.input_vec)
		var apply_persent=cos(temp_angel)
		if apply_persent>0:
			self.amount=int(MAX_amount*apply_persent)+1
			self.emitting=true
		elif apply_persent<=0:
			self.amount=1
			self.emitting=false
	elif Glo.input_vec==Vector2.ZERO:
		self.amount=1
		self.emitting=false
	export_force=force_dir*(amount-1)*particles_force_scale*parent_node.mass
	if parent_node.is_class("RigidBody2D"):
		parent_node.export_force=export_force
