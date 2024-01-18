extends Node2D
class_name BulletEmiterClass
signal BulletEmiterClass
@export var Free_mode=false

@onready var O_spread_degrees=5.0
@onready var O_speed=20
@onready var O_shoot_cd=30
@onready var O_once_shoot_num=1
@export var spread_degrees=5.0
@export var speed=20
@export var shoot_cd=30
@export var once_shoot_num=1

@export var bullet:PackedScene
@export var origin_bullet:PackedScene
@onready var export_force=Vector2.ZERO
@onready var shoot_fog=preload("res://Tscn/Particles_tscn/shoot_particles_2d.tscn")
@onready var shoot_tick=0
@onready var material_type=101
var parent_node
var shoot_pos
var is_ey
@onready var icon_node=$RayCast2D/Sprite2D
@onready var ray_node=$RayCast2D
@onready var ray_end_pos=$RayCast2D/Marker2D
func BulletEmiterClass_init():
	parent_node=self.get_parent()
	shoot_pos=self.get_node_or_null("shoot_pos")
	is_ey=parent_node.has_signal("EnemyClass")
	icon_node.material.set_shader_parameter("palette_in",load("res://PNG/Mobs/Colors/wood/N.png"))
	icon_node.material.set_shader_parameter("palette_out",load("res://PNG/Mobs/Colors/wood/N.png"))
func _physics_process(_delta):
	bullet_change()
	Emiter_Data_Change()

func Emiter_Data_Change():
	if parent_node.has_signal("MobBody2DClass"):
		shoot_cd=O_shoot_cd-PlayerData.Sum_ShootCd_Decrese
		shoot_cd=clampf(shoot_cd,1,1200)
		once_shoot_num=O_once_shoot_num+PlayerData.Sum_OnceBulletNum_Add
		once_shoot_num=clampi(once_shoot_num,1,12)
		speed=O_speed+PlayerData.Sum_Bullet_InitSpeed_Add
		speed=clampf(speed,1,1200)

func bullet_change():
	match [is_ey]:
		[true]:
			pass
		[false]:
			var temp_mobs=get_tree().get_nodes_in_group("Assembly_0")
			var has_special_bullet=false
			for i in temp_mobs:
				if i.special_bullet!=null:
					self.bullet=i.special_bullet
					has_special_bullet=true
			if has_special_bullet==false:
				self.bullet=origin_bullet


func _process(_delta):
	icon_node.visible=Free_mode
	if parent_node.is_destoryed==true:
		icon_node.material.shader=null
	else :
		icon_node.material.shader=load("res://Tres/shader/pattle_swap.gdshader")
		if material_type!=parent_node.material_type:
			material_type=parent_node.material_type
			icon_change(material_type)

	match [is_ey]:
		[true]:
			barrel_control()
			shoot_control()
		[false]:
			if parent_node.Father_node==Glo.player:
				if parent_node.is_destoryed==false:
					barrel_control()
					shoot_control()
					force_deliver()


func barrel_control():
	var target_pos=Vector2.ZERO
	match [is_ey]:
		[true]:
			target_pos=Glo.player_pos
		_:
			target_pos=get_global_mouse_position()
	if Free_mode:self.look_at(target_pos)
	else :pass

func shoot():
	var bullet_temp=bullet.instantiate()
	spawn_bullet(bullet_temp)
	var temp_vec=caculate_vec()
	bullet_temp.linear_velocity=temp_vec
	add_effects(temp_vec,bullet_temp)
	export_force=-temp_vec*bullet_temp.mass*50

func spawn_bullet(tp_bullet):
	tp_bullet.material_type=parent_node.material_type
	self.get_node(Glo.world_path).add_child(tp_bullet)
	var temp_spawn_pos=shoot_pos.global_position+Vector2(randf_range(-2,2),randf_range(-2,2))
	tp_bullet.global_translate(temp_spawn_pos)
func caculate_vec():
	var temp_velocity:Vector2=(shoot_pos.global_position-self.global_position)*speed
	var rand_angel=randf_range(-spread_degrees,spread_degrees)
	temp_velocity=temp_velocity.rotated(deg_to_rad(rand_angel))+parent_node.linear_velocity/2
	return temp_velocity
func add_effects(tp_vec,tp_bullet):
	var power_cost=tp_bullet.mass*(tp_bullet.material_type%100)
#	var power_cost=1
	if parent_node.has_signal("MobBody2DClass"):
		parent_node.State="scale"
		self.get_node("AudioStreamPlayer2D").playing=true
		spawn_fog(tp_vec)
		PlayerData.power-=power_cost
	else :
		spawn_fog(tp_vec)

func shoot_control():
	match [is_ey]:
		[true]:
			var temp_len=(self.global_position-Glo.player_pos).length()
			if temp_len<=140:
				shoot_tick+=1
				if shoot_tick>=shoot_cd:
					for i in once_shoot_num:
						shoot()
					shoot_tick=0
		[false]:
			if Input.is_action_just_pressed("ui_shoot"):
				shoot_tick+=29
			if Input.is_action_pressed("ui_shoot"):
				shoot_tick+=1
				if shoot_tick>=shoot_cd:
					for i in once_shoot_num:
						if PlayerData.power>0:
							shoot()
					shoot_tick=0

func force_deliver():
	if parent_node.has_signal("MyRigidClass"):
		parent_node.export_force=+export_force
	export_force=lerp(export_force,Vector2.ZERO,0.5)

func spawn_fog(temp_velocity):
	var fog_temp=shoot_fog.instantiate()
	self.get_node(Glo.world_path).add_child(fog_temp)
	fog_temp.global_position=shoot_pos.global_position
	fog_temp.rotation=temp_velocity.angle()
	fog_temp.emitting=true

func icon_swap_color(path):
	icon_node.material.set_shader_parameter("palette_out",load(path))

func icon_change(type):
	match [type]:
		[101]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/N.png")
		[102]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/R.png")
		[103]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/SR.png")
		[104]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/SSR.png")
		[201]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/N.png")
		[202]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/R.png")
		[203]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/SR.png")
		[204]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/SSR.png")
		[301]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/N.png")
		[302]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/R.png")
		[303]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/SR.png")
		[304]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/SSR.png")
		_:pass
