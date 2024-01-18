extends EnemyClass
func _ready():
	EnemyClass_init()

func _on_animation_player_animation_finished(_anim_name):
	State="move_forword"
