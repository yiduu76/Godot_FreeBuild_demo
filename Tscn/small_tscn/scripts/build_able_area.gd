extends Area2D
@onready var pre_attach_node:MobBody2DClass=null
@onready var attach_node:MobBody2DClass=null
@onready var attach_null=true
@onready var overlaping=false
func _ready():
	self.area_entered.connect(Callable(self, "mob_area_attch"))
	self.area_exited.connect(Callable(self, "mob_area_leave"))
func _physics_process(_delta):
	self.visible=Glo.build_mode
	self.set_collision_layer_value(1,Glo.build_mode)
	self.set_collision_mask_value(1,Glo.build_mode)

	if overlaping:
		if pre_attach_node.pin_null==false:
			attach_node=pre_attach_node
	if attach_node!=null:
		attach_null=false
		if attach_node.pin_null==true:
			attach_null=true
			attach_node=null

func mob_area_attch(area):
	if area.is_in_group("detect_area"):
		overlaping=true
		pre_attach_node=area.get_parent()

func mob_area_leave(area):
	if area.is_in_group("detect_area"):
		overlaping=false
		pre_attach_node=null

