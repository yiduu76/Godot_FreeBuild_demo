extends EnemyClass
@onready var spread_degrees=5.0
func _ready():
	EnemyClass_init()


func _on_animation_player_animation_finished(anim_name):
	if anim_name=="move_forword":
		State="attk"
	elif anim_name=="attk":
		constant_force/=2
		constant_torque/=2
		angular_velocity/=2
		linear_velocity/=2
		State="move_forword"
	else :
		State="move_forword"
