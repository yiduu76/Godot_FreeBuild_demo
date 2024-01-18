extends EnemyClass
func _ready():
	EnemyClass_init()


func _on_animation_player_animation_finished(anim_name):
	if anim_name=="move_forword":
		State="roll_to_player"
	elif anim_name=="roll_to_player":
		constant_force/=2
		constant_torque/=2
		angular_velocity/=2
		linear_velocity/=2
		State="dash"
	elif anim_name=="dash":
		State="move_forword"
	else :
		State="move_forword"

