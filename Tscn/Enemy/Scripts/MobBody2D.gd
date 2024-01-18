extends MyRigidClass
class_name  MobBody2DClass
signal  MobBody2DClass
@onready var track_mouse=false
@onready var Hovering=false
@onready var pin_null=true
@onready var picking_unlock_tick=0
@onready var picking_lock_time=60
@onready var External_force=[[null,Vector2.ZERO,Vector2.ZERO]]
@onready var reset_self_ro_tick=0
@onready var sum_force=Vector2.ZERO
@onready var export_force=Vector2.ZERO
@onready var find_self_force=false
@onready var find_tick=0
@onready var find_self_force_tick=0
@onready var force_tick=0
@onready var is_destoryed=false
@onready var rebuild_tick=0
@onready var rebuild_scale=1.0
@onready var can_build=true

@export var CN_name:String
@export var S_ShootCd_Decrese=0
@export var S_OnceBulletNum_Add=0
@export var S_Bullet_InitSpeed_Add=0

@export var P_MaxPower_add=0
@export var P_PowerRecoverSpeed_add=0
@export var special_bullet:PackedScene
@export var special_bullet_name:String="无"

var Father_node
var force_id

func MobBody2DClass_init():
	_add_shadow_poly()
	MyRigidClass_init()
	Father_node=self
	force_id=self.get_rid()
	self.gravity_scale=0

#	self.lock_rotation=true
	self.contact_monitor=true
	self.max_contacts_reported=2
	rebuild()
	animate_node.connect("animation_finished",Callable(self,"hitted_state_back"))
	for i in self.get_children():
		if i.is_in_group("detect_area"):
			i.mouse_entered.connect(Callable(self, "mouse_entered"))
			i.mouse_exited.connect(Callable(self, "mouse_exited"))
			i.area_entered.connect(Callable(self, "detect_area_entered"))
			i.area_exited.connect(Callable(self, "detect_area_exited"))

	Glo.signal_col_off.connect(Callable(self,"col_off"))
	Glo.signal_col_on.connect(Callable(self,"col_on"))
	Glo.signal_rotate_mob.connect(Callable(self,"rotate_mob"))
	Glo.signal_rotate_main.connect(Callable(self,"rotate_main"))

func _physics_process(delta):
	all_cut()
	all_build()
	limit_speed(10.0)
	if is_destoryed==true:
		_rebuilding(delta)
		self.constant_force=Vector2.ZERO
	elif is_destoryed==false:
		self.constant_force=export_force
	self.freeze=Glo.build_mode
	animate_node.play(State)

	if Hovering==true&&Glo.build_mode:
		if pin_null==true&&Input.is_action_just_pressed("ui_accept"):
			Glo.pick_node=self
		if Input.is_action_just_pressed("ui_cut"):
			self.pin_out()
		if Father_node!=self&&Input.is_action_just_pressed("ui_build"):
			pin_in()
		if Input.is_action_just_pressed("ui_delete"):
			self.queue_free()
func power_add():
	PlayerData.Max_power+=self.Max_power_add
	PlayerData.power_recover_speed+=self.power_recover_speed
func power_decrese():
	PlayerData.Max_power-=self.Max_power_add
	PlayerData.power_recover_speed-=self.power_recover_speed
func pin_in():
	if Father_node==Glo.player:
		self.add_to_group("Assembly_0")
		var pin=self.get_node("PinJoint2D1")
		pin.node_a=".."
		pin.node_b=pin.get_path_to(Father_node)
		pin_null=false
	Glo.pick_node=null

func pin_out():
	if self!=Glo.player:
		self.remove_from_group("Assembly_0")
	var pin=self.get_node("PinJoint2D1")
	pin.node_a=".."
	pin.node_b=".."
	pin_null=true
	Father_node=self
	self.linear_velocity=Vector2.ZERO
	self.constant_force=Vector2.ZERO
func _dead(_pos):
	destoryed()
func destoryed():
	self.remove_from_group("Assembly_0")
#	print(self.get_groups())
	icon.material.shader=null
	is_destoryed=true
	self.modulate.a=0.01
	mass=0.01
	self.set_collision_layer_value(2,false)
	self.set_collision_mask_value(1,false)
	self.set_collision_mask_value(3,false)
func _rebuilding(delta):
	if PlayerData.player_coin[303]>=0:
		var recover_health=delta*materia_recover_scale
		var recover_cost=recover_health/materia_recover_scale
		PlayerData.player_coin[303]-=recover_cost/2.0
		rebuild_tick+=recover_health
		rebuild_scale=rebuild_tick/value
		self.modulate.a=rebuild_scale
		if rebuild_tick>=value:
			self.add_to_group("Assembly_0")
			rebuild()
			is_destoryed=false
			rebuild_tick=0
			set_new_health()
func rebuild():
	icon.material.shader=load("res://Tres/shader/pattle_swap.gdshader")
	is_destoryed=false
	icon.modulate.a=1.0
	set_new_mass()
	self.set_collision_layer_value(2,true)
	self.set_collision_mask_value(1,true)
	self.set_collision_mask_value(3,true)


func mouse_entered():
	Hovering=true
func mouse_exited():
	Hovering=false

func detect_area_entered(area):
	if area.is_in_group("detect_area"):
		can_build=false
	if area.is_in_group("build_able_area")&&can_build:
		Father_node=area.get_parent().Father_node
func detect_area_exited(area):
	if area.is_in_group("build_able_area"):
		pass
	if area.is_in_group("detect_area"):
		can_build=true
func col_off():
	pass
func col_on():
	pass
func rotate_mob(degrees):
	if Glo.pick_node==self:
		rotation_degrees+=degrees
func rotate_main(degrees):
	if self.Father_node==Glo.player:
		rotation_degrees+=degrees
func all_cut():
	if Input.is_action_just_pressed("ui_strong_cut"):
		pin_out()
func all_build():
	if Input.is_action_just_pressed("ui_strong_build"):
		pin_in()

func hitted_state_back(_anim_name):
	State="move_forword"
