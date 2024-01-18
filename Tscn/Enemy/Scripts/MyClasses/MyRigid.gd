extends RigidBody2D
class_name MyRigidClass
signal MyRigidClass
@onready var smash_par=preload("res://Tscn/Particles_tscn/smash_particles_2d.tscn")
@onready var dam_num_scn=preload("res://Tscn/small_tscn/dam_num.tscn")
@onready var State="move_forword"
@onready var smash_pos=Vector2.ZERO
@export var length:int=8
@onready var max_speed=80.0
@export var material_type:int=101
@onready var material_mass_scale=1.0
@onready var materia_health_scale=1.0
@onready var materia_recover_scale=1.0
@onready var materia_physics_additon=1.0
@onready var materia_physics_resist=1.0
@onready var materia_energy_additon=1.0
@onready var materia_energy_resist=1.0

@export var shape_type:int=1
@onready var shape_size_scale=1.0
@onready var shape_health_scale=1.0
@onready var shape_recover_scale=1.0
@onready var shape_physics_additon=1.0
@onready var shape_physics_resist=1.0
@onready var shape_energy_additon=1.0
@onready var shape_energy_resist=1.0
@onready var health=64.0
@onready var value=10.0
@onready var Elite_level:int=0
var icon
var animate_node:AnimationPlayer

func MyRigidClass_init():
	self.add_to_group("MyRigidClass")
	if self.get_node_or_null("Sprite2D")==null:
		icon=self.get_node_or_null("Polygon2D")
	else :
		icon=self.get_node_or_null("Sprite2D")
	animate_node=self.get_node_or_null("AnimationPlayer")
	no_connect_init()
	icon.material.set_shader_parameter("palette_in",load("res://PNG/Mobs/Colors/wood/N.png"))
	self.connect("body_entered",Callable(self,"_impact"))
func no_connect_init():
	shape_effect_match(shape_type)
	material_effect_match(material_type)

func _add_shadow_poly():
	var col_node=self.get_node_or_null("CollisionPolygon2D")
	if col_node!=null:
		var temp_node=LightOccluder2D.new()
		self.add_child(temp_node)
		temp_node.occluder=OccluderPolygon2D.new()
		temp_node.occluder.polygon=col_node.polygon

func spawn_dam_num(dam):
	var temp=dam_num_scn.instantiate()
	self.get_node(Glo.world_path).add_child(temp)
	var temp_line=temp.get_node("Node").get_node("Line2D")
	temp_line.add_point(self.global_position)
	temp_line.add_point(self.global_position+Vector2(dam/10,0))
	temp.global_position=self.global_position
	temp.text=str(int(dam))

func _impact(body):
	if self.get_node_or_null("AnimationPlayer")!=null:
		self.State="hitted"
	match [body.has_signal("MyRigidClass")]:
		[true]:
			var impulse_power=(self.linear_velocity-body.linear_velocity).length()
			var dam=impulse_power*body.mass*(body.materia_physics_additon/self.materia_physics_resist)
			var temp_dir:Vector2=self.global_position-body.global_position
			var temp_angle=temp_dir.angle()
			var temp_par=smash_par.instantiate()
			self.get_parent().add_child(temp_par)
			smash_pos=body.global_position+temp_dir.normalized()
			temp_par.global_position=smash_pos
			temp_par.rotation=temp_angle+deg_to_rad(90)
			dam=clamp(dam,1,9999)
			match [self.has_signal("EnemyClass"),self.has_signal("MobBody2DClass")]:
				[true,false]:#敌人
					match [body.has_signal("EnemyClass")]:
						[true]:
							health-=clamp(dam/4,1,10)
							spawn_dam_num(dam)
						_:
							health-=dam
							spawn_dam_num(dam)
				[false,true]:#部件
					match [body.has_signal("MobBody2DClass")]:
						[true]:
							health-=clamp(dam/4,1,10)
							spawn_dam_num(dam)
						_:
							health-=dam
							spawn_dam_num(dam)
				[false,false]:#子弹
					health-=dam
				_:
					pass
		[false]:
			var dam=1
			health-=dam
#			var impulse_power=self.linear_velocity.length()/10
#			var dam=impulse_power
			var temp_par=smash_par.instantiate()
			self.get_parent().add_child(temp_par)
			smash_pos=self.global_position
			temp_par.global_position=smash_pos
			temp_par.rotation=deg_to_rad(randf_range(0,360))
#			health-=dam
	if int(health)<=0:
		_dead(self.global_position)

func _dead(_pos):
	self.queue_free()

func set_material_scales(MS,MH,MR,PA,PR,EA,ER):
	var Elite_offset=Elite_level/50.0
	material_mass_scale=MS-Elite_offset
	materia_health_scale=MH+Elite_offset*5
	materia_recover_scale=MR+Elite_offset
	materia_physics_additon=PA+Elite_offset
	materia_physics_resist=PR+Elite_offset
	materia_energy_additon=EA+Elite_offset
	materia_energy_resist=ER+Elite_offset
func icon_swap_color(path):
	if icon==null:
		pass
	else :
		icon.material.set_shader_parameter("palette_out",load(path))

func material_effect_match(type):
	material_type=type
	match [type]:
		[101]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/N.png")
			set_material_scales(1,0.9,1.8,0.96,0.96,1.8,0.9)#木-N
		[102]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/R.png")
			set_material_scales(1.5,1.05,2.1,1.12,1.12,2.1,1.05)#红木-R
		[103]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/SR.png")
			set_material_scales(2,1.2,2.4,1.28,1.28,2.4,1.2)#紫檀-SR
		[104]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/SSR.png")
			set_material_scales(2.5,1.35,2.7,1.44,1.44,2.7,1.35)#乌木-SSR
		[201]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/N.png")
			set_material_scales(2.4,1.5,0.72,1.32,1.32,0.9,0.9)#钢-R
		[202]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/R.png")
			set_material_scales(3.6,1.75,0.84,1.54,1.54,1.05,1.05)#铀-SR
		[203]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/SR.png")
			set_material_scales(4.8,2,0.96,1.76,1.76,1.2,1.2)#钨-SSR
		[204]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/SSR.png")
			set_material_scales(6,2.25,1.08,1.98,1.98,1.35,1.35)#钨钢合金-UR
		[301]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/N.png")
			set_material_scales(2.2,1.2,0.96,1.08,0.84,1.5,0.9)#铜-R
		[302]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/R.png")
			set_material_scales(3.3,1.4,1.12,1.26,0.98,1.75,1.05)#银-SR
		[303]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/SR.png")
			set_material_scales(4.4,1.6,1.28,1.44,1.12,2,1.2)#金-SSR
		[304]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/SSR.png")
			set_material_scales(5.5,1.8,1.44,1.62,1.26,2.25,1.35)#秘银合金-UR
		_:pass
	set_new_mass()
	set_new_health()
	set_new_value()
func set_new_mass():
	var area_size=length*length*shape_size_scale
	mass=area_size*material_mass_scale/100
func set_new_health():
	var area_size=length*length*shape_size_scale
	health=area_size*shape_health_scale*materia_health_scale*shape_health_scale
func set_new_value():
	var level=material_type%100
	value=health+(materia_recover_scale/1.0)*30+(materia_physics_additon+shape_physics_additon)*30\
	+(materia_physics_resist+shape_physics_additon)*30+level*100
	value=value*randf_range(0.6,1.6+(level/10.0))
	value=int(value/10)

func set_shape_scales(SZ,SH,SR,PA,PR,EA,ER):
	shape_size_scale=SZ
	shape_health_scale=SH
	shape_recover_scale=SR
	shape_physics_additon=PA
	shape_physics_resist=PR
	shape_energy_additon=EA
	shape_energy_resist=ER
func shape_effect_match(type):
	match [type]:
		[0]:set_shape_scales(1.0,1.0,1.0,1.0,1.0,1.0,1.0)#原型
		[1]:set_shape_scales(0.8,1.2,1.5,0.8,1.2,1.2,1.2)#圆型
		[2]:set_shape_scales(0.8,0.5,0.8,0.5,0.5,0.7,0.7)#长方型
		[3]:set_shape_scales(0.5,1.2,0.9,1.4,0.9,0.7,0.7)#三角型
		[4]:set_shape_scales(1.0,1.0,1.0,0.5,0.8,1.0,1.0)#正方型
		[5]:set_shape_scales(0.5,1.2,5.0,9.0,1.0,0.7,0.7)#近战专用型
		_:pass

func limit_speed(temp_speed):
	max_speed=temp_speed*20
	var speed_len=self.linear_velocity.length()
	if speed_len>=max_speed:
		linear_damp=speed_len/12
	else :
		linear_damp=0.1
