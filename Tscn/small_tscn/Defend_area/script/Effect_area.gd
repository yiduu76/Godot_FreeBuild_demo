extends Area2D
@export var Effect_strength=28
@export var area_size=16.0
@export var mode:int=0
var parent_node
func _ready():
	parent_node=self.get_parent()
	$CollisionShape2D.shape.radius=area_size
	$MeshInstance2D.mesh.radius=area_size/16/2
	$MeshInstance2D.mesh.height=area_size/16
	
func _physics_process(_delta):
	var is_ey=parent_node.has_signal("EnemyClass")
	if is_ey:
		pass
	else :
		var rebuild_scale=self.get_parent().rebuild_scale
		self.scale.x=rebuild_scale
		self.scale.y=rebuild_scale

func _on_body_entered(body):
	match [mode]:
		[0]:
			if body.has_signal("BulletClass"):
				body.beEffecting=true
				body.Effect_souce=self
				body.Effect_strength=Effect_strength
		_:pass
		
func _on_body_exited(body):
	match [mode]:
		[0]:
			if body.has_signal("BulletClass"):
				body.beEffecting=false
				body.Effect_souce=null
		_:pass
