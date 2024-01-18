extends MobBody2DClass
func _ready():
	MobBody2DClass_init()
	Glo.player=self
func _process(_delta):
	Glo.player_pos=self.global_position
