extends MyRigidClass
class_name BulletClass
signal BulletClass
@export var Trace_mode=0
@export var Divide_num=0
@export var Trace_strength=10.0
@onready var Life_time=1.0
@onready var beEffecting=false
@onready var Effect_strength=10

@onready var last_pos=Vector2.ZERO
@onready var vec_dir=Vector2.ZERO
@onready var init_rand_vec=Vector2.RIGHT
@onready var vec_angel=0.0
@export var Bullet_health=1
var Effect_souce
var path

func BulletClass_init():
	path=$line_path

func _physics_process(_delta):
	vec_dir=self.global_position-last_pos
	_spawn_path()
	last_pos=self.global_position
	vec_angel=vec_dir.angle()
	icon.rotation=vec_angel+deg_to_rad(45)
	beEffect()
	_time_limit()
	Trace_mode_move(Trace_mode)
		
func Trace_mode_move(mode):
	match [mode]:
		[0]:
			pass
		[2]:
			var self_target=Glo.player
			var temp_pos:Vector2=self_target.global_position
			var temp_dir:Vector2=(temp_pos-self.global_position)
			temp_dir=temp_dir.normalized()
			self.constant_force=temp_dir*Trace_strength
		[1]:
			var self_target=null
			if Glo.lock_target!=null&&self_target==null:
				self_target=Glo.lock_target
				var temp_pos:Vector2=self_target.global_position
				var temp_dir:Vector2=(temp_pos-self.global_position)
				temp_dir=temp_dir.normalized()
				self.constant_force=temp_dir*Trace_strength
		_:
			pass

func beEffect():
	if beEffecting==true&&Effect_souce!=null:
		var Effect_dir:Vector2=(self.global_position-Effect_souce.global_position)
		Effect_dir=Effect_dir.normalized()
		if Effect_strength>=0:
			self.constant_force=Effect_dir*Effect_strength
		elif Effect_strength<0:
			self.constant_force=self.linear_velocity*(Effect_strength/128.0)
			
	elif beEffecting==false||Effect_souce!=null:
		self.constant_force=Vector2.ZERO

func _spawn_path():
	path.line_size=length
	if last_pos!=Vector2.ZERO:
		path.point_array.append(last_pos)
	path.icon_change(material_type)

func _time_limit():
	health-=0.05
	if health<=0:
		divide(self.position)
		_dead(self.position)
func divide(pos):
	if Divide_num>0:
		var load_temp=load("res://Tscn/Bullets/O_1_bullet.tscn")
		Divide_num=clamp(Divide_num,0,10)
		for i in Divide_num:
			var temp=load_temp.instantiate()
			self.get_node(Glo.world_path).add_child(temp)
			temp.global_position=pos
			temp.Divide_num=0
			temp.health=0.4
			var rand_angel=randf_range(0,360)
			var rand_vec_scale=randf_range(0.5,1.5)
			init_rand_vec=vec_dir.rotated(deg_to_rad(rand_angel+180))
			temp.linear_velocity=init_rand_vec*50*rand_vec_scale
	else :
		return

