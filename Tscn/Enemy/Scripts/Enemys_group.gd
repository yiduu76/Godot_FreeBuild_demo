extends Node
@onready var Ey_point=100.0
@onready var Elite_level:int=0
@onready var rand_wave_scale=0.3
@onready var time_value_tick=0
@onready var wave_value_tick=0

@onready var spawn_tick=0
@onready var spawn_need_tick=10
@onready var enemy_group_node=$Enemys
@onready var spawner=preload("res://Tscn/small_tscn/enemy_spawner.tscn")
@onready var wall=preload("res://Tscn/wall.tscn")
var last_Wall
var edge_points
var center_points

func _ready():
	edge_points=spawn_circle_points(300)
	center_points=spawn_circle_points(28)
	Glo.Ey_spawn_forword.connect(Callable(self,"spawn_Ey_spawner"))
	Glo.emit_signal("Ey_spawn_forword",rand_enemy_point(),Glo.world_scene_type,rand_spawner_num())
func spawn_Ey_spawner(ey_point,ey_type,ey_num):
	edge_points=spawn_circle_points(randi_range(280,350))
	var wave_rand_num_1=randf_range(-1,1)
	var wave_rand_num_2=randf_range(-1,1)
	var rand_spawn_type=randi_range(0,5)
	for i in ey_num:
		var rand_point=randf_range(0.7,1.3)*(ey_point/(ey_num-i))
		var temp:Enemy_spawner=spawner.instantiate()
		enemy_group_node.add_child(temp)
		temp.global_translate(rand_pos(rand_spawn_type,wave_rand_num_1,wave_rand_num_2))
#		temp.global_translate(rand_pos(5,wave_rand_num_1,wave_rand_num_2))
		temp.material_type=ey_type
		temp.Elite_level=Elite_level
		temp.enemy_point=rand_point
		ey_point-=rand_point

func rand_pos(type,wave_rand_num_1,wave_rand_num_2):
	var temp_pos=Vector2.ZERO
	match [type]:
		[0]:#完全随机空投
			var limit_x=256
			temp_pos.x=randi_range(-limit_x,limit_x)+Glo.sun_pos.x
			temp_pos.y=randi_range(-limit_x,limit_x)+Glo.sun_pos.y
			return temp_pos
		[1]:#完全随机边缘进入
			var temp_i=randi_range(0,edge_points.size()-1)
			temp_pos=Glo.sun_pos+edge_points[temp_i]
			return temp_pos
		[2]:#集中边缘进入
			var rand_density=randf_range(0.1,0.3)
			wave_rand_num_1=clampf(wave_rand_num_1,0,(1.0-rand_density))
			var rand_start=int(wave_rand_num_1*edge_points.size())
			var rand_end=int((wave_rand_num_1+rand_density)*edge_points.size())-1
			var temp_i=randi_range(rand_start,rand_end)
			temp_pos=Glo.sun_pos+edge_points[temp_i]
			return temp_pos
		[3]:#完全随机集团空降
			var limit_x=48
			var rand_center_x=200*wave_rand_num_1
			var rand_center_y=200*wave_rand_num_2
			temp_pos.x=randi_range(-limit_x,limit_x)+Glo.sun_pos.x+rand_center_x
			temp_pos.y=randi_range(-limit_x,limit_x)+Glo.sun_pos.y+rand_center_y
			return temp_pos
		[4]:#边缘随机集团空降
			var limit_x=48
			if wave_rand_num_1>=0:
				wave_rand_num_1=0.8+0.2*wave_rand_num_1
			elif wave_rand_num_1<0:
				wave_rand_num_1=-0.8+0.2*wave_rand_num_1
			if wave_rand_num_2>=0:
				wave_rand_num_2=0.8+0.2*wave_rand_num_2
			elif wave_rand_num_2<0:
				wave_rand_num_2=-0.8+0.2*wave_rand_num_2
			var rand_center_x=200*wave_rand_num_1
			var rand_center_y=200*wave_rand_num_2
			temp_pos.x=randi_range(-limit_x,limit_x)+Glo.sun_pos.x+rand_center_x
			temp_pos.y=randi_range(-limit_x,limit_x)+Glo.sun_pos.y+rand_center_y
			return temp_pos
		[5]:#完全中心空投
			var temp_i=randi_range(0,center_points.size()-1)
			temp_pos=Glo.sun_pos+center_points[temp_i]
			return temp_pos
		[6]:#直线生成
			pass
		[7]:#特殊形状生成
			pass
		_:
			pass

func spawn_circle_points(radius):
	var seg=int(radius/2)
	var points_array=[]
	var seg_num=seg+1
	for i in seg_num:
		points_array.append(Vector2.ZERO)
	for i in seg_num:
		var angel=(i)*(360.0/seg)
		points_array[i]=Vector2(radius*cos(deg_to_rad(angel)),radius*sin(deg_to_rad(angel)))
	return points_array

func rand_enemy_point():
	var time_scale=0.05*(time_value_tick/60.0)+1
	var wave_scale=Glo.wave_num*0.05+1
	Ey_point=time_scale*wave_scale*PlayerData.total_value
	return Ey_point

func rand_type():
	var last_num=0
	var first_num=randi_range(1,3)
	last_num=int(Ey_point/300.0)+1
	Elite_level=int(last_num/4.0)
	last_num=last_num-Elite_level*4
	last_num=clampi(last_num,1,4)
	Glo.world_scene_type=first_num*100+last_num
	return Glo.world_scene_type
func _on_timer_timeout():
	$Timer.start(0)
	time_value_tick+=1
	Glo.spawn_tick+=1
	Glo.spawn_need_tick=60+enemy_group_node.get_child_count()*3
	if Glo.spawn_tick>=Glo.spawn_need_tick:
		Glo.wave_num+=1
		Glo.spawn_tick=0
		Glo.emit_signal("Ey_spawn_forword",rand_enemy_point(),rand_type(),rand_spawner_num())

func rand_spawner_num():
	var num=randi_range(4,12)
	return num
