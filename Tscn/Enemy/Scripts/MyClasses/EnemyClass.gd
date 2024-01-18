extends MyRigidClass
class_name EnemyClass
signal EnemyClass
var forword_pos:Marker2D
var timer_node:Timer
@onready var is_destoryed=false
@export var Have_engine:bool=true
@export var Target_player:bool=true
@export var Aim_target:bool=true
@export var is_random=false
@export var speed=8.0
@export var turn_speed=1.0
@export var divide_child:PackedScene=null
@onready var target_pos=Vector2.ZERO
@onready var forword_dir=Vector2.ZERO
@onready var export_force=Vector2.ZERO
@export var path_to_father:NodePath="."
@onready var Father_node=null

@onready var move_par=preload("res://Tscn/Particles_tscn/Ey_move_par.tscn")
@onready var die_par=preload("res://Tscn/Particles_tscn/die_particles_2d.tscn")
@onready var broken_par=preload("res://Tscn/Particles_tscn/broken_part.tscn")
@onready var coin_scn=preload("res://Tscn/small_tscn/coin.tscn")
@onready var line_tscn=preload("res://Tscn/small_tscn/line_path.tscn")

@onready var addtion_1_tscn=preload("res://Tscn/small_tscn/Defend_area/Effect_area.tscn")
@onready var bullet_emiter=preload("res://Tscn/small_tscn/bullet_emiter.tscn")
var broken_parts
var path

func add_path():
	var temp_path=line_tscn.instantiate()
	self.add_child(temp_path)
	path=temp_path
func add_par():
	var temp_par=move_par.instantiate()
	self.add_child(temp_par)

func EnemyClass_init():
	_add_shadow_poly()
	add_path()
	add_par()
	forword_pos=$Marker2D
	timer_node=$Timer
	pin_in()
#	_visable_()
	set_collision_layer_value(3,true)
	set_collision_mask_value(1,true)
	set_collision_mask_value(2,true)
	MyRigidClass_init()
	rand_speed()
	rand_turn_speed()
	rand_defence_add()
	rand_weapon_add()
func rand_weapon_add():
	var rand_num=randf_range(0,100)
	if rand_num<=33:
		var emiter_temp:BulletEmiterClass
		emiter_temp=bullet_emiter.instantiate()
		self.add_child(emiter_temp)
		var rand_scale=randf_range(-1.0,1.0)
		if rand_scale>=0:
			emiter_temp.Free_mode=false
		else :
			emiter_temp.Free_mode=true
		emiter_temp.speed=randi_range(5,35)
		
		emiter_temp.shoot_cd=int(60+30*rand_scale)
		
		emiter_temp.once_shoot_num=int(1+2*randf_range(-1.0,1.0))
		
		emiter_temp.spread_degrees=randi_range(1,10)
		
		emiter_temp.bullet=load("res://Tscn/Bullets/Ey_O_1_bullet.tscn")
		
		emiter_temp.origin_bullet=load("res://Tscn/Bullets/Ey_O_1_bullet.tscn")
		
func rand_defence_add():
	var rand_num=randf_range(0,100)
	if rand_num<=7:
		var temp=addtion_1_tscn.instantiate()
		temp.area_size=randi_range(8,48)
		self.add_child(temp)
		temp.Effect_strength=randf_range(0,64)
		temp.area_size=randi_range(32,128)
	elif rand_num<=10:
		var temp=addtion_1_tscn.instantiate()
		temp.area_size=randi_range(8,48)
		self.add_child(temp)
		temp.Effect_strength=randf_range(-64,0)
	else :
		pass

func rand_speed():
	speed=randf_range(0.8,1.6)*speed
func rand_turn_speed():
	turn_speed=randf_range(0.8,1.6)*turn_speed

func _physics_process(_delta):
	_move()
	_spawn_path()
	animate_node.play(State)
	
func _spawn_path():
	path.line_size=length/1.5
	var last_pos=self.global_position
	if last_pos!=Vector2.ZERO:
		path.point_array.append(last_pos)
	path.icon_change(material_type)

func _visable_():
	var temp=VisibleOnScreenEnabler2D.new()
	self.add_child(temp)

func pin_in():
	Father_node=self.get_node_or_null(path_to_father)
	if Father_node!=null:
		var temp_joint:PinJoint2D=self.get_node("PinJoint2D")
		temp_joint.node_a=".."
		temp_joint.node_b=temp_joint.get_path_to(Father_node)

func _move():
	limit_speed(speed)
	update_target()
	if Have_engine:
		move_forword()
	else :
		constant_force=Vector2.ZERO
	if Aim_target:
		turn_to_target()
	
func update_target():
	if Target_player==true:
		target_pos=Glo.player_pos
	elif Target_player==false:
		var target_node=self.get_node_or_null(self.path_to_father)
		if target_node!=null:
			target_pos=(self.global_position-target_node.global_position)+self.global_position
		else :
			Have_engine=true
			Target_player=true
			Aim_target=true

func move_forword():
	self.constant_force=export_force

func turn_to_target():
	var target_dir=target_pos-self.global_position
	var self_dir=Vector2.ZERO
	var angel_gap=0.0
	self_dir.x=cos(self.rotation)
	self_dir.y=sin(self.rotation)
	angel_gap=self_dir.angle_to(target_dir)
	self.apply_torque(rad_to_deg(angel_gap)*mass*turn_speed)

func _dead(pos):
	var temp_par_1=broken_par.instantiate()
	self.get_node(Glo.world_path).add_child(temp_par_1)
	temp_par_1.global_translate(pos)

	var temp_par_2=die_par.instantiate()
	self.get_node(Glo.world_path).add_child(temp_par_2)
	temp_par_2.global_translate(pos)
	
	_divide()
	var temp_num=value*randf_range(0.5,1.5)/10
	temp_num=clampi(temp_num,1,20)
	spawn_rand_coin(temp_num)
	self.queue_free()

func spawn_rand_coin(num:int):
	for i in num:
		var temp_coin=coin_scn.instantiate()
#		temp_coin.material_type=self.material_type
		temp_coin.material_type=303
		self.get_node(Glo.world_path).call_deferred("add_child",temp_coin)
		temp_coin.global_translate(self.global_position)

func _divide():
	if divide_child!=null:
		var rand_num=randi_range(0,4)
		for i in rand_num:
			var temp=divide_child.instantiate()
			self.get_parent().call_deferred("add_child",temp)
			temp.material_type=self.material_type
			temp.global_translate(self.global_position)
