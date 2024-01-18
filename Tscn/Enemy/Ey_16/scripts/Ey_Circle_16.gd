extends EnemyClass
func _ready():
	EnemyClass_init()
func _process(_delta):
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name=="move_forword":
		State="roll"
	elif anim_name=="roll":
		self.constant_force=Vector2.ZERO
		self.constant_torque=0.0
		self.angular_velocity=0.0
		self.linear_velocity=Vector2.ZERO
		State="dash"
	elif anim_name=="dash":
		State="move_forword"
	else :
		State="move_forword"
