extends MobBody2DClass
func _ready():
	MobBody2DClass_init()

func _process(_delta):
	self.constant_torque=Input.get_axis("ui_left","ui_right")*1000
